const ETAPAS = ["ABERTA", "EM_ANDAMENTO", "PRONTA", "ENTREGUE"];

const NOMES_STATUS = {
  ABERTA: "Aberta",
  EM_ANDAMENTO: "Em andamento",
  PRONTA: "Pronta para retirar",
  ENTREGUE: "Entregue",
  CANCELADA: "Cancelada"
};

const form = document.getElementById("form-consulta");
const botao = form.querySelector("button");
const caixaErro = document.getElementById("erro");
const resultado = document.getElementById("resultado");

form.addEventListener("submit", async (evento) => {
  evento.preventDefault();

  const numero = document.getElementById("numero").value.trim();
  const telefone = document.getElementById("telefone").value.trim();

  esconder(caixaErro);
  esconder(resultado);
  botao.disabled = true;

  try {
    mostrarOs(await buscarOs(numero, telefone));
  } catch (erro) {
    mostrarErro(erro);
  } finally {
    botao.disabled = false;
  }
});

function mostrarOs(os) {
  texto("os-numero", os.numero);
  texto("os-equipamento", os.equipamento);
  texto("os-aberta", formatarData(os.aberta_em));
  texto("os-previsao", formatarData(os.previsao));
  texto("os-diagnostico", os.diagnostico || "Ainda em análise");
  texto("os-valor", formatarValor(os.valor_total));

  const selo = document.getElementById("os-status");
  selo.textContent = NOMES_STATUS[os.status];
  selo.className = "selo " + os.status.toLowerCase();

  montarLinhaDoTempo(os.status);
  resultado.hidden = false;
}

function montarLinhaDoTempo(status) {
  const lista = document.getElementById("linha-do-tempo");
  lista.innerHTML = "";

  // OS cancelada não tem andamento pra mostrar
  if (status === "CANCELADA") {
    return;
  }

  const atual = ETAPAS.indexOf(status);

  ETAPAS.forEach((etapa, indice) => {
    const item = document.createElement("li");
    item.textContent = NOMES_STATUS[etapa];
    item.classList.toggle("feito", indice <= atual);
    lista.appendChild(item);
  });
}

function mostrarErro(erro) {
  caixaErro.textContent = "Não consegui consultar agora. Tente de novo em alguns minutos.";

  if (erro instanceof OsNaoEncontrada) {
    caixaErro.textContent = "Não achei nenhuma OS com esse número e telefone. Confira os dados.";
  }

  caixaErro.hidden = false;
}

function formatarData(dataIso) {
  if (!dataIso) {
    return "Sem previsão";
  }

  const [ano, mes, dia] = dataIso.split("-");
  return `${dia}/${mes}/${ano}`;
}

function formatarValor(valor) {
  if (!valor) {
    return "A definir";
  }

  return valor.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });
}

function texto(id, valor) {
  document.getElementById(id).textContent = valor;
}

function esconder(elemento) {
  elemento.hidden = true;
}
