#!/bin/bash
# ══════════════════════════════════════════════════════════════
# IMPORTADOR DE DESAFIOS CTFd via API
# Dell Academy CTF 2026
# ══════════════════════════════════════════════════════════════
# USO: bash import_challenges.sh http://SEU_IP:8000 TOKEN_ADMIN
# 
# Para obter o TOKEN:
#   1. Acesse http://SEU_IP:8000/admin
#   2. Vá em: Admin Panel → Config → Access Tokens  
#   3. Clique "Generate" → copie o token
#   OU vá em Settings → Access Tokens → Generate
# ══════════════════════════════════════════════════════════════

CTFD_URL="${1:-http://localhost:8000}"
TOKEN="ctfd_f20e5925de4a8e5423d67f6dada1d489895461e0ae571fb1f05dfe50f17faee6"

API="$CTFD_URL/api/v1"
AUTH="Authorization: Token $TOKEN"
CT="Content-Type: application/json"

echo "═══════════════════════════════════════════"
echo "  Importando 40 desafios no CTFd"
echo "  URL: $CTFD_URL"
echo "═══════════════════════════════════════════"

# Testar conexão
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -H "$AUTH" "$API/challenges")
if [ "$STATUS" != "200" ]; then
    echo "✗ Erro de conexão ou token inválido (HTTP $STATUS)"
    exit 1
fi
echo "✓ Conexão OK"
echo ""

echo "[1/40] 🟢 Fácil César Sabe das Coisas (Criptografia)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"César Sabe das Coisas","category":"Criptografia","description":"## César Sabe das Coisas 🔐\nUm interceptador capturou a seguinte mensagem cifrada:\n```\nIODJ{fdhvdu_q4r_hk_vhjxur}\n```\nO remetente é um grande fã do Império Romano. Decodifique a mensagem.\n**Formato:** `FLAG{...}`","value":100,"initial":100,"minimum":30,"decay":15,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{caesar_n4o_eh_seguro}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Julio César usava uma cifra de substituição com deslocamento fixo.","cost":10,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Deslocamento = 3. Desloque cada letra 3 posições para trás.","cost":20,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Fácil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Criptografia"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Cifra Clássica"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{caesar_n4o_eh_seguro}"
fi

echo "[2/40] 🟢 Fácil Bases Cobertas (Criptografia)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Bases Cobertas","category":"Criptografia","description":"## Bases Cobertas 🔢\nUm dev júnior pensou que estava \"criptografando\" dados:\n```\nRkxBR3tiNHNlNjRfaXNfbjB0X2VuY3J5cHQxb259\n```\nRecupere a informação original. **Formato:** `FLAG{...}`","value":100,"initial":100,"minimum":30,"decay":15,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{b4se64_is_n0t_encrypt1on}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"O nome do desafio é uma pista. Quantas bases você conhece?","cost":10,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Base64. Use: echo '\''<string>'\'' | base64 -d","cost":20,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Fácil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Criptografia"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Encoding"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{b4se64_is_n0t_encrypt1on}"
fi

echo "[3/40] 🟡 Médio XOR é Vida (Criptografia)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"XOR é Vida","category":"Criptografia","description":"## XOR é Vida ⊕\nMensagem cifrada com XOR (chave de 1 byte). Hex:\n```\n040e0305393a72301d2f76252b211d203b3671313f\n```\nEncontre a chave e decifre. **Formato:** `FLAG{...}`","value":250,"initial":250,"minimum":50,"decay":10,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{x0r_m4gic_byt3s}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"XOR entre primeiro byte do cifrotexto e '\''F'\'' revela a chave.","cost":25,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Chave = 0x42 (66 decimal, '\''B'\'' ASCII).","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Médio"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Criptografia"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"XOR"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{x0r_m4gic_byt3s}"
fi

echo "[4/40] 🟠 Difícil RSA Quebrado (Criptografia)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"RSA Quebrado","category":"Criptografia","description":"## RSA Quebrado 🔓\nRSA com parâmetros fracos. Download: `rsa_challenge.txt`\nFatore `n`, calcule chave privada e decifre. **Formato:** `FLAG{...}`","value":400,"initial":400,"minimum":100,"decay":5,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{sm4ll_pr1mes_b1g_pr0blems}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"O valor de '\''n'\'' é fatorável. Tente factordb.com ou sympy.factorint().","cost":40,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"p=61, q=53. phi=(p-1)*(q-1), d=pow(e,-1,phi), m=pow(c,d,n).","cost":80,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Difícil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Criptografia"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"RSA"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{sm4ll_pr1mes_b1g_pr0blems}"
fi

echo "[5/40] 🔴 Expert Vigenère Não Morreu (Criptografia)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Vigenère Não Morreu","category":"Criptografia","description":"## Vigenère Não Morreu 📜\nCifra de Vigenère com chave desconhecida. Download: `vigenere_cipher.txt`\nUse Kasiski + análise de frequência. **Formato:** `FLAG{...}`","value":500,"initial":500,"minimum":150,"decay":3,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{v1genere_kasiski_fr3q_analysis}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Comprimento da chave = 6.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Chave = '\''CRYPTO'\''.","cost":100,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Expert"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Criptografia"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Vigenère"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Criptanálise"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{v1genere_kasiski_fr3q_analysis}"
fi

echo "[6/40] 🟢 Fácil Header Hunter (Segurança de Redes)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Header Hunter","category":"Segurança de Redes","description":"## Header Hunter 🌐\nServidor vazando info nos headers HTTP. Analise `http_response.txt`. **Formato:** `FLAG{...}`","value":100,"initial":100,"minimum":30,"decay":15,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{http_h3aders_r3veal_s3crets}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Examine headers customizados (X-*).","cost":10,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Procure X-Secret-Flag.","cost":20,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Fácil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Segurança de Redes"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"HTTP"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{http_h3aders_r3veal_s3crets}"
fi

echo "[7/40] 🟡 Médio DNS Exfiltration (Segurança de Redes)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"DNS Exfiltration","category":"Segurança de Redes","description":"## DNS Exfiltration 📡\nConsultas DNS suspeitas detectadas. Analise `dns_queries.log`.\nFiltre queries para 'evil-c2.attacker.com', concatene subdomínios (hex) e converta. **Formato:** `FLAG{...}`","value":250,"initial":250,"minimum":50,"decay":10,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{dns_3xf1l_d4ta_thr0ugh_qu3ries}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Subdomínios de evil-c2.attacker.com contêm hex.","cost":25,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Concatene hex na ordem dos timestamps e converta para ASCII.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Médio"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Segurança de Redes"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"DNS"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Exfiltração"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{dns_3xf1l_d4ta_thr0ugh_qu3ries}"
fi

echo "[8/40] 🟡 Médio Packet Inspector (Segurança de Redes)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Packet Inspector","category":"Segurança de Redes","description":"## Packet Inspector 🔍\nTráfego de rede capturado. Analise `capture_log.txt`. Credenciais em texto claro. **Formato:** `FLAG{...}`","value":250,"initial":250,"minimum":50,"decay":10,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{ftp_cr3ds_1n_pl41nt3xt}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Protocolos em texto claro: FTP, Telnet, HTTP Basic.","cost":25,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Filtre pacotes FTP. Procure USER e PASS.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Médio"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Segurança de Redes"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"PCAP"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"FTP"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{ftp_cr3ds_1n_pl41nt3xt}"
fi

echo "[9/40] 🟠 Difícil Firewall Misconfiguration (Segurança de Redes)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Firewall Misconfiguration","category":"Segurança de Redes","description":"## Firewall Misconfiguration 🧱\nErros na config do firewall. Analise `firewall_rules.conf`.\nA flag está no comentário de uma regra sombreada (shadowed). **Formato:** `FLAG{...}`","value":400,"initial":400,"minimum":100,"decay":5,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{fw_rul3_0rd3r_m4tt3rs}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Regra '\''shadowed'\'' = nunca executada porque uma anterior já faz match.","cost":40,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Rule 08 (ACCEPT ALL 192.168.0.0/16) sombra Rule 12 (DROP 3306). Leia o comentário.","cost":80,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Difícil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Segurança de Redes"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Firewall"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{fw_rul3_0rd3r_m4tt3rs}"
fi

echo "[10/40] 🔴 Expert Man in the Middle (Segurança de Redes)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Man in the Middle","category":"Segurança de Redes","description":"## Man in the Middle 👤\nARP Spoofing detectado. Analise `arp_attack.log`.\nIdentifique o atacante e decodifique o payload Base64. **Formato:** `FLAG{...}`","value":500,"initial":500,"minimum":150,"decay":3,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{4rp_sp00f_d3tect3d_mitm}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"MAC aa:bb:cc:dd:ee:ff é o atacante impersonando o gateway.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Decodifique a última linha Base64.","cost":100,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Expert"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Segurança de Redes"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"ARP Spoofing"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"MITM"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{4rp_sp00f_d3tect3d_mitm}"
fi

echo "[11/40] 🟢 Fácil Robôs Indiscretos (Segurança Web)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Robôs Indiscretos","category":"Segurança Web","description":"## Robôs Indiscretos 🤖\nAdmin escondeu página secreta. Analise `robots.txt`. **Formato:** `FLAG{...}`","value":100,"initial":100,"minimum":30,"decay":15,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{r0bots_txt_1s_n0t_s3cur1ty}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"robots.txt lista diretórios que não devem ser indexados.","cost":10,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Leia os comentários do arquivo.","cost":20,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Fácil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Segurança Web"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Reconhecimento"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{r0bots_txt_1s_n0t_s3cur1ty}"
fi

echo "[12/40] 🟡 Médio SQLi 101 (Segurança Web)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"SQLi 101","category":"Segurança Web","description":"## SQLi 101 💉\nSQL Injection no login. Analise `login.php`. A flag está na tabela `secrets`. **Formato:** `FLAG{...}`","value":250,"initial":250,"minimum":50,"decay":10,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{sql_1nj3ct10n_1s_d4ng3rous}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"O campo username é concatenado diretamente na query SQL.","cost":25,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Veja o dump da tabela nos comentários do código.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Médio"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Segurança Web"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"SQL Injection"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"OWASP"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{sql_1nj3ct10n_1s_d4ng3rous}"
fi

echo "[13/40] 🟡 Médio Token Forjado (Segurança Web)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Token Forjado","category":"Segurança Web","description":"## Token Forjado 🎫\nJWT com algoritmo \"none\". Analise `jwt_info.txt`. Forje token admin. **Formato:** `FLAG{...}`","value":250,"initial":250,"minimum":50,"decay":10,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{jwt_n0ne_4lg0_bypass}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Algoritmo '\''none'\'' permite tokens sem assinatura.","cost":25,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Altere role para admin, use alg:none. A flag está no jwt_info.txt.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Médio"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Segurança Web"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"JWT"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Autenticação"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{jwt_n0ne_4lg0_bypass}"
fi

echo "[14/40] 🟠 Difícil Cookie Monster (Segurança Web)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Cookie Monster","category":"Segurança Web","description":"## Cookie Monster 🍪\nApp Flask vulnerável a XSS. Analise `vulnerable_app.py`.\nCookie admin_session contém flag em Base64. **Formato:** `FLAG{...}`","value":400,"initial":400,"minimum":100,"decay":5,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{xss_c00k1e_st34l1ng_r3fl3cted}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Parâmetro '\''search'\'' refletido sem sanitização.","cost":40,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Decodifique Base64 do cookie: RkxBR3t4c3NfYzAwazFlX3N0MzRsMW5nX3IzZmwzY3RlZH0=","cost":80,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Difícil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Segurança Web"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"XSS"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"OWASP"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{xss_c00k1e_st34l1ng_r3fl3cted}"
fi

echo "[15/40] 🔴 Expert IDOR Explorer (Segurança Web)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"IDOR Explorer","category":"Segurança Web","description":"## IDOR Explorer 🔎\nAPI com IDOR. Analise `api_documentation.json`.\nGET /api/users/1/profile com token do user 5 retorna dados do admin. **Formato:** `FLAG{...}`","value":500,"initial":500,"minimum":150,"decay":3,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{1d0r_brok3n_4cc3ss_c0ntrol}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Mude o ID na URL de 5 para 1 usando o mesmo token.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Perfil do admin (ID 1) contém a flag no campo '\''secret_note'\''.","cost":100,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Expert"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Segurança Web"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"IDOR"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"API"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"OWASP"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{1d0r_brok3n_4cc3ss_c0ntrol}"
fi

echo "[16/40] 🟢 Fácil Metadados Reveladores (Forense Digital)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Metadados Reveladores","category":"Forense Digital","description":"## Metadados Reveladores 📷\nMetadados EXIF com info sensível. Analise `metadata_info.txt`. **Formato:** `FLAG{...}`","value":100,"initial":100,"minimum":30,"decay":15,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{m3tad4ta_3xp0s3s_s3crets}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Examine campos como '\''User Comment'\'' e '\''Image Description'\''.","cost":10,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Flag está no campo '\''User Comment'\''.","cost":20,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Fácil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Forense Digital"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Metadados"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"EXIF"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{m3tad4ta_3xp0s3s_s3crets}"
fi

echo "[17/40] 🟡 Médio Log Detective (Forense Digital)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Log Detective","category":"Forense Digital","description":"## Log Detective 🕵️\nAtividade suspeita nos logs. Analise `access.log`.\nFiltre requests do IP 10.66.6.66, concatene paths hex de /exfil/ e converta. **Formato:** `FLAG{...}`","value":250,"initial":250,"minimum":50,"decay":10,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{l0g_4nalys1s_f1nds_3v1dence}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Filtre requests com IP 10.66.6.66 e path /exfil/.","cost":25,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Concatene os segmentos hex e converta para ASCII.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Médio"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Forense Digital"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Logs"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Análise"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{l0g_4nalys1s_f1nds_3v1dence}"
fi

echo "[18/40] 🟠 Difícil Memory Forensics (Forense Digital)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Memory Forensics","category":"Forense Digital","description":"## Memory Forensics 🧠\nStrings de dump de memória. Analise `memory_strings.txt`.\nConcatene EXFIL_PART1+PART2+... e decodifique Base64. **Formato:** `FLAG{...}`","value":400,"initial":400,"minimum":100,"decay":5,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{v0l4t1l3_m3m0ry_4n4lys1s}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Filtre variáveis EXFIL_PART*.","cost":40,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Concatene os valores e decodifique Base64.","cost":80,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Difícil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Forense Digital"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Memória"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Volatility"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{v0l4t1l3_m3m0ry_4n4lys1s}"
fi

echo "[19/40] 🟠 Difícil Timeline Reconstruction (Forense Digital)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Timeline Reconstruction","category":"Forense Digital","description":"## Timeline Reconstruction 🕐\nIncidente de segurança. Analise `incident_timeline.csv`.\nÚltimo evento de exfiltração contém flag em hex. **Formato:** `FLAG{...}`","value":400,"initial":400,"minimum":100,"decay":5,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{t1mel1ne_r3c0nstruct10n_k3y}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Ordene cronologicamente. Último evento do atacante = exfiltração.","cost":40,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Campo details do evento '\''exfiltration'\'' contém hex. Converta para ASCII.","cost":80,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Difícil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Forense Digital"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Incident Response"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Timeline"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{t1mel1ne_r3c0nstruct10n_k3y}"
fi

echo "[20/40] 🔴 Expert Hidden in Plain Sight (Forense Digital)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Hidden in Plain Sight","category":"Forense Digital","description":"## Hidden in Plain Sight 👁️\nEsteganografia LSB em PGM. Analise `hidden_image.pgm`.\nExtraia LSB de cada pixel, agrupe em bytes, converta para ASCII. **Formato:** `FLAG{...}`","value":500,"initial":500,"minimum":150,"decay":3,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{st3g0_lsb_h1dd3n_b1ts}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"LSB = bit menos significativo: pixel_value & 1. Agrupe de 8 em 8.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Script: bits=[str(p&1) for p in pixels]; bytes de 8 bits -> chr().","cost":100,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Expert"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Forense Digital"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Esteganografia"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"LSB"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{st3g0_lsb_h1dd3n_b1ts}"
fi

echo "[21/40] 🟢 Fácil Strings of Fate (Engenharia Reversa)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Strings of Fate","category":"Engenharia Reversa","description":"## Strings of Fate 🧵\nSaída do comando `strings` no binário. Analise `binary_strings.txt`. **Formato:** `FLAG{...}`","value":100,"initial":100,"minimum":30,"decay":15,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{str1ngs_cmd_1s_y0ur_fr1end}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Use grep para filtrar: grep '\''FLAG'\'' binary_strings.txt","cost":10,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"A flag está diretamente no arquivo.","cost":20,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Fácil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Engenharia Reversa"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Strings"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{str1ngs_cmd_1s_y0ur_fr1end}"
fi

echo "[22/40] 🟡 Médio Python Obfuscado (Engenharia Reversa)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Python Obfuscado","category":"Engenharia Reversa","description":"## Python Obfuscado 🐍\nScript Python ofuscado. Analise `obfuscated.py`. Decodifique chr() chain. **Formato:** `FLAG{...}`","value":250,"initial":250,"minimum":50,"decay":10,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{pyth0n_d30bfusc4t10n_m4st3r}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"O código usa chr() para construir strings. Substitua exec por print.","cost":25,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"_0x1337 contém a flag. Decodifique cada chr().","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Médio"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Engenharia Reversa"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Python"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Ofuscação"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{pyth0n_d30bfusc4t10n_m4st3r}"
fi

echo "[23/40] 🟡 Médio Assembly Decoder (Engenharia Reversa)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Assembly Decoder","category":"Engenharia Reversa","description":"## Assembly Decoder 🔧\nAssembly x86-64 constrói string na stack. Analise `code.asm`.\nConverta cada valor hex dos MOV BYTE para ASCII. **Formato:** `FLAG{...}`","value":250,"initial":250,"minimum":50,"decay":10,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{4ss3mbly_b4s1cs_x86}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"MOV BYTE coloca caracteres ASCII na stack. Hex -> char.","cost":25,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Leia sequencialmente: 0x46='\''F'\'', 0x4C='\''L'\'', 0x41='\''A'\'', 0x47='\''G'\''...","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Médio"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Engenharia Reversa"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Assembly"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"x86"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{4ss3mbly_b4s1cs_x86}"
fi

echo "[24/40] 🟠 Difícil CrackMe Challenge (Engenharia Reversa)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"CrackMe Challenge","category":"Engenharia Reversa","description":"## CrackMe Challenge 💀\nCadeia de transformações: ROT13→XOR(0x55)→Base64. Analise `crackme.py`.\nInverta as operações para encontrar a senha (= flag). **Formato:** `FLAG{...}`","value":400,"initial":400,"minimum":100,"decay":5,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{cr4ckm3_x0r_r0t13_ch41n}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Inverta: Base64_decode → XOR(0x55) → ROT13.","cost":40,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"s=base64.b64decode(EXPECTED); s=bytes([b^0x55 for b in s]); codecs.decode(s,'\''rot_13'\'')","cost":80,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Difícil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Engenharia Reversa"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Crackme"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{cr4ckm3_x0r_r0t13_ch41n}"
fi

echo "[25/40] 🔴 Expert Layer Cake (Engenharia Reversa)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Layer Cake","category":"Engenharia Reversa","description":"## Layer Cake 🎂\n5 camadas de encoding. Analise `layer_cake.py`.\nDesfaça: Base32→XOR(0xAA)→Reverse→Base64→Hex. **Formato:** `FLAG{...}`","value":500,"initial":500,"minimum":150,"decay":3,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{mult1_l4y3r_3nc0d1ng_unw1nd}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"5 camadas: Hex→Base64→Reverse→XOR(0xAA)→Base32. Inverta a ordem.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Base32_decode→XOR(0xAA)→Reverse→Base64_decode→Hex_decode.","cost":100,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Expert"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Engenharia Reversa"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Encoding"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Multi-layer"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{mult1_l4y3r_3nc0d1ng_unw1nd}"
fi

echo "[26/40] 🟢 Fácil Permissões Perigosas (Linux / Sistemas)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Permissões Perigosas","category":"Linux / Sistemas","description":"## Permissões Perigosas 🔒\nProblemas de segurança nas permissões. Analise `directory_listing.txt`. **Formato:** `FLAG{...}`","value":100,"initial":100,"minimum":30,"decay":15,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{f1l3_p3rm1ss10ns_m4tt3r}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Procure arquivos com permissão 777 ou SUID bit.","cost":10,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"secret_flag.txt tem permissão -rwxrwxrwx (777).","cost":20,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Fácil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Linux / Sistemas"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Permissões"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{f1l3_p3rm1ss10ns_m4tt3r}"
fi

echo "[27/40] 🟡 Médio Cron Job Malicioso (Linux / Sistemas)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Cron Job Malicioso","category":"Linux / Sistemas","description":"## Cron Job Malicioso ⏰\nPersistência via crontab. Analise `crontab_dump.txt`.\nDecodifique o payload Base64 no cron do www-data. **Formato:** `FLAG{...}`","value":250,"initial":250,"minimum":50,"decay":10,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{cr0n_p3rs1st3nc3_d3t3ct3d}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Procure cron jobs com '\''base64 -d | bash'\''.","cost":25,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Decodifique o Base64 do cron www-data.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Médio"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Linux / Sistemas"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Persistência"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Crontab"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{cr0n_p3rs1st3nc3_d3t3ct3d}"
fi

echo "[28/40] 🟠 Difícil SUID Escalation (Linux / Sistemas)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"SUID Escalation","category":"Linux / Sistemas","description":"## SUID Escalation ⬆️\nEscalação de privilégios via SUID. Analise `system_enum.txt`.\nEncontre binário SUID incomum e leia /root/flag.txt. **Formato:** `FLAG{...}`","value":400,"initial":400,"minimum":100,"decay":5,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{su1d_b1n4ry_pr1v3sc}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Consulte GTFOBins para binários SUID incomuns.","cost":40,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"vim.basic com SUID: vim -c '\'':!cat /root/flag.txt'\''","cost":80,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Difícil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Linux / Sistemas"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Privilege Escalation"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"SUID"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{su1d_b1n4ry_pr1v3sc}"
fi

echo "[29/40] 🟠 Difícil Backdoor SSH (Linux / Sistemas)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Backdoor SSH","category":"Linux / Sistemas","description":"## Backdoor SSH 🚪\nChave SSH não autorizada. Analise `ssh_forensics.txt`.\nDecodifique o comentário da chave desconhecida (Base64). **Formato:** `FLAG{...}`","value":400,"initial":400,"minimum":100,"decay":5,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{ssh_b4ckd00r_4uth0r1z3d_k3ys}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"3ª chave tem comentário em Base64.","cost":40,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Decodifique: RkxBR3tzc2hfYjRja2QwMHJfNHV0aDByMXozZF9rM3lzfQ==","cost":80,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Difícil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Linux / Sistemas"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"SSH"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Backdoor"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{ssh_b4ckd00r_4uth0r1z3d_k3ys}"
fi

echo "[30/40] 🔴 Expert Container Breakout (Linux / Sistemas)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Container Breakout","category":"Linux / Sistemas","description":"## Container Breakout 🐳\nDocker socket montado dentro do container. Analise `container_info.txt`.\nEscape do container e acesse o host. **Formato:** `FLAG{...}`","value":500,"initial":500,"minimum":150,"decay":3,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{d0ck3r_s0ck3t_3sc4pe_r00t}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Docker socket (/var/run/docker.sock) permite controlar o daemon.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"docker run -v /:/host alpine cat /host/root/flag.txt","cost":100,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Expert"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Linux / Sistemas"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Docker"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Container Escape"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{d0ck3r_s0ck3t_3sc4pe_r00t}"
fi

echo "[31/40] 🟢 Fácil View Source (OSINT)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"View Source","category":"OSINT","description":"## View Source 🔍\nInfo escondida no HTML. Analise `website_source.html`.\nProcure comentários HTML. **Formato:** `FLAG{...}`","value":100,"initial":100,"minimum":30,"decay":15,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{v13w_s0urc3_html_c0mm3nts}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Comentários HTML: <!-- ... -->","cost":10,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Procure por comentários com '\''FLAG'\'' ou '\''DEBUG'\''.","cost":20,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Fácil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"OSINT"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"HTML"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Reconhecimento"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{v13w_s0urc3_html_c0mm3nts}"
fi

echo "[32/40] 🟡 Médio DNS Recon (OSINT)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"DNS Recon","category":"OSINT","description":"## DNS Recon 🌍\nRegistros DNS coletados. Analise `dns_recon.txt`.\nRegistro TXT de '_secret' contém dados Base64. **Formato:** `FLAG{...}`","value":250,"initial":250,"minimum":50,"decay":10,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{dns_r3c0n_txt_r3c0rds}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Registros TXT frequentemente contêm informações extras.","cost":25,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"_secret.dell-academy-ctf.com TXT contém Base64.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Médio"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"OSINT"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"DNS"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Reconhecimento"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{dns_r3c0n_txt_r3c0rds}"
fi

echo "[33/40] 🟡 Médio Git Exposed (OSINT)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Git Exposed","category":"OSINT","description":"## Git Exposed 📦\nCredenciais no histórico Git. Analise `git_log.txt`.\nCommit anterior à remoção contém os dados. **Formato:** `FLAG{...}`","value":250,"initial":250,"minimum":50,"decay":10,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{g1t_h1st0ry_l34ks_s3cr3ts}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Git guarda todo o histórico. Veja o commit abc1234.","cost":25,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"O .env no commit abc1234 contém API_SECRET com a flag.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Médio"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"OSINT"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Git"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Vazamento"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{g1t_h1st0ry_l34ks_s3cr3ts}"
fi

echo "[34/40] 🟠 Difícil Phishing Forensics (OSINT)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Phishing Forensics","category":"OSINT","description":"## Phishing Forensics 🎣\nHeaders de email phishing. Analise `email_headers.txt`.\nHeader X-Mailer-Flag contém flag em hex. **Formato:** `FLAG{...}`","value":400,"initial":400,"minimum":100,"decay":5,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{3m41l_h34d3rs_r3v34l_0r1g1n}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Compare From: com Received:. Veja headers X-*.","cost":40,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"X-Mailer-Flag em hex. Converta para ASCII.","cost":80,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Difícil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"OSINT"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Email"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Phishing"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{3m41l_h34d3rs_r3v34l_0r1g1n}"
fi

echo "[35/40] 🔴 Expert Digital Footprint (OSINT)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Digital Footprint","category":"OSINT","description":"## Digital Footprint 🦶\nInvestigação multi-fonte. Analise `investigation_dossier.txt`.\n4 partes em encodings diferentes. Junte todas. **Formato:** `FLAG{...}`","value":500,"initial":500,"minimum":150,"decay":3,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{d1g1t4l_f00tpr1nt_0s1nt_m4st3r}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Parte1=Hex, Parte2=Base64, Parte3=Binário, Parte4=ROT13.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Decodifique cada parte e concatene na ordem.","cost":100,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Expert"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"OSINT"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Investigação"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Multi-source"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{d1g1t4l_f00tpr1nt_0s1nt_m4st3r}"
fi

echo "[36/40] 🟢 Fácil Cyber Trivia (Misc / Trivia)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Cyber Trivia","category":"Misc / Trivia","description":"## Cyber Trivia 🧠\nResponda as perguntas em `trivia_quiz.txt`. **Formato:** `FLAG{...}`","value":100,"initial":100,"minimum":30,"decay":15,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{kn0wl3dg3_1s_p0w3r}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Respostas: NIST, CVE, 443, MITRE, CIA.","cost":10,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"A flag está no final do arquivo.","cost":20,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Fácil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Misc / Trivia"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Conhecimento"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{kn0wl3dg3_1s_p0w3r}"
fi

echo "[37/40] 🟢 Fácil Encoding Matryoshka (Misc / Trivia)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Encoding Matryoshka","category":"Misc / Trivia","description":"## Encoding Matryoshka 🪆\nCamadas de encoding. Analise `matryoshka.txt`.\nHex → Base64 → Flag. **Formato:** `FLAG{...}`","value":100,"initial":100,"minimum":30,"decay":15,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{3nc0d1ng_n0t_3ncrypt10n}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Primeiro decodifique hex para texto.","cost":10,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Hex → texto Base64 → decodifique Base64 → flag.","cost":20,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Fácil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Misc / Trivia"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Encoding"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{3nc0d1ng_n0t_3ncrypt10n}"
fi

echo "[38/40] 🟡 Médio Esolang Madness (Misc / Trivia)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Esolang Madness","category":"Misc / Trivia","description":"## Esolang Madness 🤯\nValores ASCII decimais. Analise `esolang_code.txt`.\nConverta cada número para caractere. **Formato:** `FLAG{...}`","value":250,"initial":250,"minimum":50,"decay":10,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{3s0l4ng_br41nf_d3c0d3}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Cada número é um valor ASCII.","cost":25,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Python: '\'''\''.join(chr(int(n)) for n in seq.split('\'','\''))","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Médio"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Misc / Trivia"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"ASCII"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Encoding"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{3s0l4ng_br41nf_d3c0d3}"
fi

echo "[39/40] 🟠 Difícil Maze Runner (Misc / Trivia)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"Maze Runner","category":"Misc / Trivia","description":"## Maze Runner 🏃\nResolva o labirinto em `maze.txt`. Letras no caminho = flag. **Formato:** `FLAG{...}`","value":400,"initial":400,"minimum":100,"decay":5,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{m4z3_s0lv3r_bfs_4lg0}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Use BFS. '\''#'\''=parede, '\''.'\''=caminho, letras=coletáveis.","cost":40,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Caminho coleta: F,L,A,G,{,m,4,z,3,_,s,0,l,v,3,r,_,b,f,s,_,4,l,g,0,}","cost":80,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Difícil"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Misc / Trivia"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Programação"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Algoritmo"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{m4z3_s0lv3r_bfs_4lg0}"
fi

echo "[40/40] 🔴 Expert The Final Boss (Misc / Trivia)"
RESP=$(curl -s -X POST "$API/challenges" \
  -H "$AUTH" -H "$CT" \
  -d '{"name":"The Final Boss","category":"Misc / Trivia","description":"## The Final Boss 🏆\n5 estágios multi-disciplina. Analise `final_boss.txt`.\nCada estágio revela uma parte da flag. **Formato:** `FLAG{...}`","value":500,"initial":500,"minimum":150,"decay":3,"function":"logarithmic","type":"dynamic","state":"visible"}')
CID=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -z "$CID" ]; then echo "  ✗ Erro ao criar challenge"; else
  curl -s -X POST "$API/flags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"FLAG{y0u_4r3_th3_ctf_ch4mp10n}","type":"static","data":"case_sensitive"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Estágio 1: ROT13. Estágio 2: porta 443. Estágio 3: hex→ASCII.","cost":50,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/hints" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"content":"Partes: y0u, 4r3, th3, ctf, ch4mp10n.","cost":100,"type":"standard"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Expert"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Misc / Trivia"}' > /dev/null
  curl -s -X POST "$API/tags" -H "$AUTH" -H "$CT" -d '{"challenge_id":'$CID',"value":"Multi-disciplina"}' > /dev/null
  echo "  ✓ ID=$CID | Flag: FLAG{y0u_4r3_th3_ctf_ch4mp10n}"
fi


# ══════════════════════════════════════════════════════════════
# CONFIGURAR HORÁRIOS DO CTF
# ══════════════════════════════════════════════════════════════
echo ""
echo "Configurando horários do CTF..."

# Start: 21/02/2026 14:00:00 BRT (UTC-3) = 17:00:00 UTC
# End:   21/02/2026 22:00:00 BRT (UTC-3) = 01:00:00 UTC (22/02)
curl -s -X PATCH "$API/configs" -H "$AUTH" -H "$CT" \
  -d '{"start":"2026-02-21T17:00:00+00:00","end":"2026-02-22T01:00:00+00:00"}' > /dev/null

echo "  ✓ Início: 21/02/2026 14:00 BRT"
echo "  ✓ Fim:    21/02/2026 22:00 BRT"

echo ""
echo "═══════════════════════════════════════════"
echo "  ✓ IMPORTAÇÃO COMPLETA!"
echo "  40 desafios importados com flags, hints e tags"
echo "  Horários configurados: 14:00 - 22:00 BRT"
echo "═══════════════════════════════════════════"
