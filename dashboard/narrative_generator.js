/* ============================================================
   DETERMINISTIC NARRATIVE GENERATOR
   ------------------------------------------------------------
   Converts the model's Shapley output into plain-English clinical
   language. Rule-based and fully deterministic: the same admission
   always produces the same text. No language model, no API call,
   no network dependency, and no capacity to hallucinate.

   Clinical thresholds below are conventional adult reference
   ranges, used only to describe the patient's recorded values in
   words. They are NOT model logic and do not affect the score.
   ============================================================ */

const REF = {
  hgb:   {low: 12.0, crit: 9.0,  unit: 'g/dL'},
  na:    {low: 135,  high: 145,  unit: 'mmol/L'},
  creat: {high: 1.5, crit: 3.0,  unit: 'mg/dL'},
  wbc:   {low: 4.0,  high: 11.0, unit: 'K/uL'},
  plt:   {low: 150,  high: 450,  unit: 'K/uL'}
};

function describeValue(key, v) {
  if (v === null || v === undefined) return null;
  const r = REF[key];
  switch (key) {
    case 'hgb':
      if (v < r.crit) return `marked anaemia (haemoglobin ${v} ${r.unit})`;
      if (v < r.low)  return `anaemia (haemoglobin ${v} ${r.unit})`;
      return `a normal haemoglobin of ${v} ${r.unit}`;
    case 'na':
      if (v < r.low)  return `hyponatraemia (sodium ${v} ${r.unit})`;
      if (v > r.high) return `hypernatraemia (sodium ${v} ${r.unit})`;
      return `a sodium within range (${v} ${r.unit})`;
    case 'creat':
      if (v >= r.crit) return `markedly elevated creatinine (${v} ${r.unit})`;
      if (v > r.high)  return `elevated creatinine (${v} ${r.unit})`;
      return `a creatinine within range (${v} ${r.unit})`;
    case 'wbc':
      if (v > r.high) return `a raised white cell count (${v} ${r.unit})`;
      if (v < r.low)  return `a low white cell count (${v} ${r.unit})`;
      return `a white cell count within range (${v} ${r.unit})`;
    case 'plt':
      if (v < r.low)  return `thrombocytopenia (platelets ${v} ${r.unit})`;
      if (v > r.high) return `thrombocytosis (platelets ${v} ${r.unit})`;
      return `platelets within range (${v} ${r.unit})`;
  }
  return null;
}

// Maps a model feature to a clinical phrase for THIS patient.
function phraseFor(feature, p) {
  switch (feature) {
    case 'hemoglobin_mean_imputed':   return describeValue('hgb', p.hgb);
    case 'sodium_mean_imputed':       return describeValue('na', p.na);
    case 'creatinine_mean_imputed':   return describeValue('creat', p.creat);
    case 'wbc_mean_imputed':          return describeValue('wbc', p.wbc);
    case 'platelet_count_mean_imputed': return describeValue('plt', p.plt);
    case 'hematocrit_mean_imputed':   return 'the recorded haematocrit';
    case 'admission_type': {
      const MAP = {
        'DIRECT EMER.': 'a direct emergency admission',
        'EW EMER.': 'an emergency department admission',
        'URGENT': 'an urgent admission',
        'ELECTIVE': 'an elective admission',
        'SURGICAL SAME DAY ADMISSION': 'a same-day surgical admission',
        'OBSERVATION ADMIT': 'an observation admission',
        'DIRECT OBSERVATION': 'a direct observation encounter',
        'EU OBSERVATION': 'an emergency observation encounter'
      };
      return MAP[(p.adm || '').toUpperCase()] || `a ${(p.adm || 'recorded').toLowerCase()} admission`;
    }
    case 'length_of_stay_days': {
      if (p.los >= 14) return `a prolonged ${p.los}-day stay`;
      if (p.los <= 1)  return `a very short ${p.los}-day stay`;
      return `a ${p.los}-day length of stay`;
    }
    case 'insurance': return `payer category (${p.ins})`;
    case 'race':      return 'recorded race/ethnicity';
  }
  return null;
}

// Intervention suggestions keyed to the drivers actually present.
function actionsFor(p, risingFeatures) {
  const a = [];
  const has = f => risingFeatures.indexOf(f) >= 0;

  if (has('hemoglobin_mean_imputed') && p.hgb !== null && p.hgb < 12)
    a.push('Review anaemia before discharge — consider iron studies and a haematology follow-up plan.');
  if (has('creatinine_mean_imputed') && p.creat !== null && p.creat > 1.5)
    a.push('Recheck renal function within 7 days and review nephrotoxic medications.');
  if (has('sodium_mean_imputed') && p.na !== null && (p.na < 135 || p.na > 145))
    a.push('Repeat electrolytes post-discharge; correct sodium before the patient leaves if feasible.');
  if (has('wbc_mean_imputed') && p.wbc !== null && (p.wbc > 11 || p.wbc < 4))
    a.push('Confirm any active infection is resolving before discharge is finalised.');
  if (has('admission_type') && (p.adm || '').toUpperCase().indexOf('EMER') >= 0)
    a.push('Unplanned admission — schedule a transitional care call within 48 hours.');
  if (has('length_of_stay_days') && p.los >= 14)
    a.push('Prolonged stay — assess deconditioning and confirm home support is in place.');
  if (p.labs === 0)
    a.push('No laboratory data recorded — obtain baseline bloods before relying on this score.');

  if (p.tier === 'High') {
    a.push('Complete the full discharge bundle: medication reconciliation, teach-back, and a follow-up appointment within 7 days.');
  } else if (p.tier === 'Medium') {
    a.push('Standard discharge planning with a 7-day follow-up call.');
  } else {
    a.push('Standard discharge pathway; no enhanced intervention indicated by the model.');
  }
  return a;
}

function buildNarrative(p, baseline) {
  const sorted = [...p.shap].sort((x, y) => Math.abs(y.v) - Math.abs(x.v));
  const rising  = sorted.filter(s => s.v > 0);
  const falling = sorted.filter(s => s.v < 0);

  // --- headline ---
  const ratio = p.risk / baseline;
  let rel;
  if (ratio >= 1.75)      rel = 'well above';
  else if (ratio >= 1.15) rel = 'above';
  else if (ratio >= 0.85) rel = 'close to';
  else if (ratio >= 0.5)  rel = 'below';
  else                    rel = 'well below';
  const headline =
    `This admission is scored <b>${(p.risk * 100).toFixed(1)}%</b> — ${rel} the population average of ` +
    `${(baseline * 100).toFixed(1)}% — placing it in the <b>${p.tier.toLowerCase()}-risk</b> tier.`;

  // --- drivers ---
  const risePhrases = rising.slice(0, 3).map(s => phraseFor(s.f, p)).filter(Boolean);
  let driverText = '';
  if (risePhrases.length === 0) {
    driverText = 'No individual factor pushes this admission materially above baseline.';
  } else {
    const joined = risePhrases.length === 1
      ? risePhrases[0]
      : risePhrases.slice(0, -1).join(', ') + ' and ' + risePhrases[risePhrases.length - 1];
    driverText = `The score is driven mainly by ${joined}.`;
  }

  // --- protective factors ---
  const fallPhrases = falling.slice(0, 2).map(s => phraseFor(s.f, p)).filter(Boolean);
  let protectiveText = '';
  if (fallPhrases.length) {
    const joined = fallPhrases.length === 1
      ? fallPhrases[0]
      : fallPhrases.join(' and ');
    protectiveText = ` Offsetting this, the model treats ${joined} as reducing risk.`;
  }

  // --- non-clinical driver caveat ---
  const nonClinical = rising.slice(0, 3).filter(s => s.f === 'insurance' || s.f === 'race');
  let governanceText = '';
  if (nonClinical.length) {
    const names = nonClinical.map(s => s.l.toLowerCase()).join(' and ');
    governanceText =
      `<div class="narr-flag"><b>Governance note.</b> ${names.charAt(0).toUpperCase() + names.slice(1)} ` +
      `appears among the top contributors for this admission. These are non-clinical attributes included for ` +
      `fairness auditing. They must not be used as a reason to allocate or withhold care — see the equity review.</div>`;
  }

  // --- low-confidence caveat ---
  let confidenceText = '';
  if (p.labs === 0) {
    confidenceText =
      `<div class="narr-flag"><b>Low confidence.</b> No laboratory results are recorded, so all six lab ` +
      `features fall back to the -999 sentinel. The score rests almost entirely on administrative fields and ` +
      `should not be relied on without baseline bloods.</div>`;
  }

  return {
    headline: headline,
    body: driverText + protectiveText,
    flags: governanceText + confidenceText,
    actions: actionsFor(p, rising.map(s => s.f))
  };
}
