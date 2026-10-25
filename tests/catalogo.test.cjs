const fs = require('fs');
const assert = require('assert/strict');
const data = JSON.parse(fs.readFileSync('research/catalogo-lios.json', 'utf8'));
const html = fs.readFileSync('catalogo.html', 'utf8');
const embedded = JSON.parse(html.match(/<script id="catalogueData" type="application\/json">([\s\S]*?)<\/script>/)[1]);
assert.deepEqual(embedded, data, 'HTML gerado deve conter a versão exata da base revisada');
assert.equal(data.lenses.length, 33);
assert.equal(new Set(data.lenses.map(x => x.id)).size, 33);
for (const lens of data.lenses) {
  assert(lens.sources.length, lens.id + ': exige referência');
  for (const id of lens.sources) assert(data.sources[id], lens.id + ': fonte inexistente');
  for (const key of ['near_d', 'intermediate_d']) assert(lens.addition[key] === null || (Number.isFinite(lens.addition[key]) && lens.addition[key] > 0), lens.id + ': ausência não pode virar zero');
  assert.equal(lens.addition.plane, 'LIO');
  assert(lens.addition.status, lens.id + ': exige estado de confirmação');
  assert.equal(lens.curve.points.length, 0, 'v1 não deve gerar pontos artificiais para ' + lens.id);
  assert.equal(lens.decision_automation, 'Não habilitada');
}
assert.equal(data.lenses.find(x => x.id === 'bios').addition.intermediate_d, 1.5);
assert.equal(data.lenses.find(x => x.id === 'odyssey').addition.near_d, null);
assert.equal(data.lenses.find(x => x.id === 'luxsmart').addition.intermediate_d, null);
assert(data.lenses.find(x => x.id === 'emv').sa.includes('positiva'));
assert.notEqual(data.lenses.find(x => x.id === 'gemetric').id, data.lenses.find(x => x.id === 'gemetric-plus').id);
console.log('PASS: base/HTML consistentes; 33 identidades, fontes, ausência distinta de zero, adições corrigidas e nenhuma curva artificial.');
