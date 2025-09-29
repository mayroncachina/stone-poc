# stone_provider

Proof of Concept (PoC) para testes de Deeplink da maquininha Stone

Este repositório contém um projeto Flutter usado como PoC para testar o fluxo
de Deep Link / Deeplink com as maquininhas da Stone (integração local via URI
scheme). O objetivo é fornecer uma base mínima para gerar, capturar e validar
intenções de pagamento enviadas para a maquininha, facilitando testes de
integração e investigação do comportamento do SDK/terminal.

## Objetivos

- Implementar um PoC simples que dispare Deeplinks para a maquininha Stone.
- Registrar e exibir respostas/retornos vindos da maquininha (se aplicável).
- Servir como referência para QA e desenvolvedores que precisam testar
	integração de pagamentos usando Deeplink.

## O que contém

- Código Flutter mínimo com telas para iniciar pagamentos e exibir resultados.
- Páginas de exemplo em `lib/pages/` que demonstram fluxos de pagamento,
	cancelamento e reimpressão.

## Como usar (rápido)

1. Abra o projeto no Android Studio / VS Code.
2. Conecte um dispositivo Android ou emulador.
3. Rode a aplicação Flutter:

	 flutter run

4. Na UI do PoC, escolha a ação de pagamento para disparar o Deeplink.
	 Observe os logs/retornos no app ou no logcat do Android para validar o
	 comportamento.

Nota: Este repositório é um PoC — não contém uma integração de produção nem
tratamento de segurança/erros para uso em ambientes reais.

## Referências

- Documentação oficial da Stone sobre Deeplink (em português):
	https://sdkandroid.stone.com.br/reference/explicacao-deeplink

Outras referências úteis podem ser encontradas na documentação do SDK Android
da Stone e nos exemplos oficiais.

## Estrutura do projeto

Principais arquivos e pastas:

- `lib/main.dart` – ponto de entrada do app.
- `lib/pages/` – telas de exemplo: `payment_page.dart`, `cancel_page.dart`,
	`print_page.dart`, `reprint_page.dart`.
- `android/` – projetos e configurações Android (onde o Deeplink/Intent pode ser
	configurado para testes locais).

## Observações e próximos passos

- Validar o esquema de URI usado pela maquininha e ajustar `AndroidManifest.xml`
	se for necessário para capturar intents no dispositivo de teste.
- Adicionar exemplos de payloads de Deeplink e testes automatizados (opcional).

Se quiser, posso:

- Atualizar o README com exemplos de payloads Deeplink específicos.
- Adicionar instruções detalhadas para configurar intents no `AndroidManifest.xml`.
- Criar pequenos scripts/testes para simular chamadas de Deeplink no emulador.

## Configurar token do PackageCloud

Para baixar o SDK privado da Stone este projeto pode precisar de um token
de leitura do PackageCloud (chave `packageCloudReadToken`). Esse token é
um segredo de acesso e não deve ser comitado no repositório.

Opções recomendadas:

- Editar localmente `android/local.properties` e adicionar a linha:

	packageCloudReadToken=SEU_TOKEN_AQUI

	Atenção: mantenha esse arquivo fora do controle de versão (adicione ao
	`.gitignore`) ou remova o token antes de commitar.

- Alternativa (mais segura): exportar uma variável de ambiente e ajustar o
	processo de build para usar essa variável. Exemplo (Linux/macOS zsh):

	export PACKAGECLOUD_READ_TOKEN=seu_token_aqui

	Em seguida adapte seu gradle/build para ler `PACKAGECLOUD_READ_TOKEN` quando
	presente, em vez de depender do arquivo `local.properties`.
