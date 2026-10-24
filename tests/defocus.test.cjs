const vm=require('vm'),fs=require('fs'),assert=require('assert'),{webcrypto}=require('crypto');
const nodes={},mem={};function el(id){return nodes[id]||(nodes[id]={value:'',children:[],style:{},dataset:{},classList:{toggle(){}},appendChild(b){this.children.push(b)},addEventListener(k,f){this[k]=f},focus(){},click(){}})}
const storage={getItem:k=>mem[k]||null,setItem:(k,v)=>{mem[k]=v},removeItem:k=>delete mem[k]};
const ctx={document:{getElementById:el,createTextNode:t=>({textContent:t}),createElement:()=>({children:[],style:{},dataset:{},classList:{toggle(){}},appendChild(b){this.children.push(b)},addEventListener(k,f){this[k]=f}})},localStorage:storage,sessionStorage:storage,crypto:webcrypto,confirm:()=>true,alert:()=>{},Date,Math,Array,Number,String,setTimeout,clearTimeout,Blob};
vm.runInNewContext(fs.readFileSync('index.html','utf8').match(/<script>([\s\S]*?)<\/script>/)[1].replace('})();','globalThis.testMakePdf=makePdf;globalThis.testSession=setSession;})();'),ctx);
assert.equal(el('lens').textContent,'+1,00 D');for(let i=0;i<10;i++)el('next').onclick();assert.equal(el('lens').textContent,'-4,00 D');el('reset').onclick();for(let i=0;i<11;i++)el('buttons').children[2].click();assert.equal(el('stage').textContent,11);assert.equal((el('results').innerHTML.match(/20\/20/g)||[]).length,11);
el('patient').value='Paciente sintético';el('iol').value='Outra';el('other').value='LIO TESTE';el('satisfaction').value='0';el('save').onclick();el('save').onclick();assert.equal(JSON.parse(mem.defocus_local_v1).length,1);const saved=JSON.parse(mem.defocus_local_v1)[0];assert.equal(saved.satisfaction,'0');assert.equal(saved.lioModel,'LIO TESTE');assert.equal(saved.protocol.length,11);assert.equal(JSON.parse(mem.defocus_draft_v2).vals.length,11);console.log('PASS: navegação, limpeza, 11 registros, salvar sem duplicação, LIO manual, satisfação zero e rascunho.');

(async()=>{
const pdf=Buffer.from(await ctx.testMakePdf().arrayBuffer());assert(pdf.toString().startsWith('%PDF-1.4'));
ctx.testSession({access_token:'synthetic',expires_at:Math.floor(Date.now()/1000)+3600});
el('mode').value='corrigido';el('distance').value='4';
ctx.AbortController=AbortController;
let calls=0;ctx.fetch=async(url,opts)=>{if(url.includes('/rpc/')){calls++;const p=JSON.parse(opts.body).p;return {ok:true,json:async()=>({...p,revision:1,patientUuid:'11111111-1111-4111-8111-111111111111'})}}return {ok:true,json:async()=>[]}};
await el('cloudSave').onclick();assert.equal(calls,1,el('syncState').textContent);assert.equal(el('syncState').textContent,'Salvo no banco');
ctx.fetch=async()=>{throw new Error('offline')};await el('cloudSave').onclick();assert(el('syncState').textContent.startsWith('Erro de sincronização'));assert.equal(JSON.parse(mem.defocus_local_v1).length,1);
console.log('PASS: confirmação remota, erro offline sem falso salvo, cópia local e PDF.');
})().catch(e=>{console.error(e);process.exitCode=1});
