# Gestão de Turnos

Aplicação de planeamento de turnos para restauração, em preparação como projeto de portefólio e com possibilidade de utilização real.

> **Implementação nova e independente.** Este projeto não é uma continuação do programa antigo. O código, as bases de dados e as configurações antigas não serão copiados nem ligados automaticamente. Qualquer futura importação de dados exige análise, mapeamento e aprovação próprios.

## Estado do projeto

O repositório está na fase de definição e preparação. A implementação deve começar depois da revisão dos requisitos, da identificação dos bloqueios e da aprovação da proposta técnica. As tecnologias e a arquitetura abaixo são propostas, não decisões aprovadas.

## Objetivo e âmbito

Planear os turnos de uma equipa de restauração, associar colaboradores a postos para os quais tenham formação validada, gerir ausências e férias e manter o histórico das alterações ao planeamento.

A aplicação regista **horários planeados**, não o registo efetivo das horas trabalhadas.

## Requisitos funcionais confirmados

### Colaboradores, postos e formação

- Registar o nome, número de colaborador, data de entrada, regime (part-time ou full-time) e formações do colaborador.
- Um colaborador desempenha um único posto em cada turno.
- Para desempenhar um posto, precisa de formação e avaliação positiva FV/A: o formador confirma que consegue executar o posto autonomamente e manter a qualidade de serviço.
- Formadores, gerentes, subgerentes e gerentes de turno podem participar na formação e validação.
- Uma avaliação FV negativa implica repetir a formação.
- O colaborador pode mudar de posto entre turnos se tiver a formação validada para o novo posto.

### Planeamento e publicação

- Gerente e subgerente podem criar e editar o planeamento.
- Gerente de turno pode atribuir postos apenas a colaboradores com formação validada para esses postos.
- Todos os utilizadores podem consultar o planeamento completo da equipa.
- Um planeamento incompleto não pode ser publicado.
- Sempre que se altera um planeamento publicado, o colaborador afetado deve ser notificado.
- As alterações ao planeamento mantêm histórico e autoria. Gerentes, subgerentes e gerentes de turno podem corrigir o planeamento.

### Horas e pausas

- Horários full-time podem ser definidos manualmente como fixos, salvo comunicação de alteração.
- Avisar quando as horas planeadas ficam abaixo das horas contratuais; bloquear um planeamento que ultrapasse essas horas.
- Mostrar as pausas no planeamento. As pausas não são descontadas às horas contratuais.
- A pausa obrigatória de 30 minutos é contínua e não pode ser dividida.
- Não trabalhar mais de cinco horas antes nem depois de uma pausa contínua de 30 minutos.

### Ausências e férias

- Qualquer colaborador pode pedir folgas ou ausências; gerente ou subgerente aprova o pedido.
- Uma ausência aprovada marca o dia como folga no planeamento.
- Reimplementar na aplicação nova o módulo de férias existente. O sistema propõe o saldo e o gerente confirma ou corrige.
- Os registos antigos de férias permanecem no sistema antigo; não se presume qualquer importação.

## Regras de negócio

- A atribuição a um posto depende de formação validada para esse posto.
- A avaliação FV negativa exige repetição da formação antes de nova validação.
- Não atribuir mais de um posto ao mesmo colaborador no mesmo turno.
- Não publicar planeamentos incompletos nem permitir que ultrapassem as horas contratuais.
- Manter autoria e histórico das alterações ao planeamento; notificar sempre o colaborador afetado por alterações após publicação.
- Aplicar o limite de cinco horas de trabalho de cada lado da pausa contínua de 30 minutos.

## Perfis e permissões conhecidas

| Perfil | Permissões confirmadas |
| --- | --- |
| Colaborador | Consultar o planeamento completo da equipa; pedir folgas ou ausências |
| Gerente | Criar e editar planeamento; aprovar ausências; confirmar ou corrigir saldo de férias |
| Subgerente | Criar e editar planeamento; aprovar ausências; confirmar ou corrigir saldo de férias |
| Gerente de turno | Atribuir postos a colaboradores com formação validada; corrigir planeamento |
| Formador | Participar na formação e validação FV/A |

As permissões detalhadas por ação, incluindo quem pode publicar e gerir contas, ainda precisam de confirmação.

## Arquitetura e tecnologias propostas

Tecnologias conhecidas no contexto do projeto: Python, Streamlit, SQLite, pandas, Plotly, Ubuntu Server, Docker/Compose e Tailscale. **A utilização de qualquer uma delas nesta aplicação ainda não foi aprovada.**

Como ponto de partida para avaliação, a Fase 0 propõe uma aplicação Python com Streamlit e SQLite, usando pandas e Plotly apenas se forem necessários. A estrutura, a base de dados, a autenticação e a infraestrutura de execução ficam por decidir. O novo ambiente de desenvolvimento e a persistência devem ser independentes do programa antigo.

## Segurança e persistência

- Não ligar a aplicação nova à base de dados antiga.
- Não copiar código, dados, migrações ou configurações antigas sem análise e autorização explícita.
- Definir uma base de dados própria para desenvolvimento e uma estratégia de cópias de segurança antes da implementação.
- Proteger os dados de colaboradores e limitar as ações conforme as permissões que vierem a ser aprovadas.
- Não alterar o programa antigo, o servidor de produção ou os serviços existentes durante a Fase 0.

Detalhes de autenticação, alojamento, retenção de dados, cópias de segurança e recuperação ainda estão por definir.

## Fases de trabalho

As fases seguintes são uma **proposta de organização**, sujeita a revisão e aprovação:

0. **Definição e preparação:** inspecionar o repositório, consolidar requisitos, identificar dúvidas e propor arquitetura, modelo de dados, ambiente isolado e estratégia de testes. Não iniciar a implementação antes da revisão e aprovação.
1. **Fundação da aplicação:** preparar estrutura, configuração e persistência próprias, depois de aprovadas as decisões técnicas.
2. **Gestão de equipa:** implementar colaboradores, postos, formação e validação.
3. **Planeamento:** implementar turnos, atribuições, horários, pausas, validação de horas, publicação e histórico.
4. **Ausências e férias:** implementar pedidos, aprovação e proposta/correção do saldo.
5. **Verificação e preparação para utilização:** validar regras, segurança, cópias de segurança, documentação e modo de execução antes de qualquer utilização real.

## Questões pendentes

- Quais são os postos de trabalho e as respetivas competências/formações?
- Quais são as horas contratuais e as regras exatas por regime ou contrato?
- Como se calcula o saldo de férias e que dados são necessários?
- Quem pode publicar um planeamento e que informação o torna completo?
- Que notificações são necessárias e por que canal serão enviadas?
- Quais são as permissões detalhadas de cada perfil e como será feita a autenticação?
- Que arquitetura, base de dados, ambiente de alojamento e estratégia de testes serão aprovados?
- Qual é o URL canónico do repositório do programa antigo? Será necessária alguma importação futura de dados?

## Separação do programa antigo

O programa antigo é uma referência técnica separada. O URL canónico deve ser confirmado. Não alterar o programa, a respetiva base de dados, infraestrutura ou repositório no âmbito deste projeto sem autorização específica.

## Contexto

Este README consolida os requisitos registados na nota principal do projeto e no plano da Fase 0 do Obsidian, consultados em 29-10-2026. Requisitos pendentes e propostas estão identificados como tal; devem ser confirmados antes de orientar a implementação.
