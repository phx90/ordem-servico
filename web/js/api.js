// Busca a OS na API. Se a API estiver fora do ar, cai nos dados de exemplo.

class OsNaoEncontrada extends Error {}

async function buscarOs(numero, finalTelefone) {
  let resposta;

  try {
    resposta = await fetch(`${API_URL}/${numero}?telefone=${finalTelefone}`);
  } catch {
    return buscarNaDemo(numero, finalTelefone);
  }

  if (resposta.status === 404) {
    throw new OsNaoEncontrada();
  }

  if (!resposta.ok) {
    throw new Error(`A API respondeu ${resposta.status}`);
  }

  return resposta.json();
}

function buscarNaDemo(numero, finalTelefone) {
  document.getElementById("aviso-demo").hidden = false;

  const os = DADOS_DEMO.find(
    (item) => item.numero === Number(numero) && item.telefone === finalTelefone
  );

  if (!os) {
    throw new OsNaoEncontrada();
  }

  return os;
}
