"""Regenera o catálogo estático a partir da base revisável. Sem dependências."""
from pathlib import Path
import json

root = Path(__file__).resolve().parent.parent
data = json.loads((root / 'research/catalogo-lios.json').read_text())
template = (root / 'research/catalogo.template.html').read_text()
payload = json.dumps(data, ensure_ascii=False).replace('<', '\\u003c')
(root / 'catalogo.html').write_text(template.replace('__CATALOGUE_JSON__', payload))

# The simulator shares the same reviewed catalogue; no independent duplicated database.
simulator_template = (root / "research/simulador.template.html").read_text()
(root / "simulador.html").write_text(simulator_template.replace("__CATALOGUE_JSON__", payload))
