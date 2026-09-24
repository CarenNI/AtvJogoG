1. As duas fases
A Fase 1 é o cenário de inverno criado na atividade 1, com o pinguim, neve, montanhas e a casinha no final. A Fase 2 foi criada com o tema floresta, usando um tileset diferente, outra paleta de cores (verdes e tons de terra e outra sensação de jogo, como pede o enunciado.

Cada fase tem: solo com colisão desenhado no TileMapLayer, plataformas suspensas que exigem pulo, uma camada de decoração separada sem colisão (árvores, arbustos, flores), extensão de mais de três telas, ponto de partida claro e ponto de fim sinalizado. A Fase 2 ainda tem um trecho de subida vertical, que também foi usado para testar o parallax vertical.

 2. Parallax
Usei um ParallaxBackground com várias camadas em velocidades diferentes. Comecei pela camada mais distante com motion_scale de 0.1 e fui aumentando 0.1 a cada camada até a mais próxima, seguindo a lógica: quanto mais longe o fundo está, mais devagar ele se move.

Na Fase 2 (floresta) usei 5 camadas de fundo, com motion_scale de 0.1 (fundo mais distante) até 0.5 (fundo mais próximo). Na Fase 1 usei 3 camadas, seguindo a mesma regra. Como a Fase 2 tem um trecho que sobe, o parallax também funciona na vertical, não só na horizontal.

3. Área secreta
A área secreta fica na Fase 2. Ela tem uma pista visível (um item à vista que chama a atenção), uma entrada que não é a pista em si, e um terreno falso sem colisão, com o z_index ajustado para o personagem sumir atrás da parede ao entrar. Coloquei também um Label com o texto "área secreta" perto da entrada para deixar claro que ali existe um caminho escondido. Dentro da área há uma recompensa que justifica explorar.

 4. Câmera
Usei uma única câmera (Camera2D) para as duas fases, criada como uma cena separada e instanciada nas duas. Ela segue o jogador procurando o nó no grupo "Player". Configurei os limites (Limit Left / Right / Top / Bottom) com valores medidos a partir do tamanho real de cada fase, para a câmera parar nas bordas e não mostrar o vazio fora do cenário.

 5. Transição entre fases
A transição usa uma cena de colisor (Area2D + CollisionShape2D) criada uma única vez e reutilizada nas duas fases e na salinha. O destino de cada colisor é configurado no Inspetor (campo next_level), não no código.

A troca de cena não pode ser chamada direto no momento da colisão porque o Godot não permite liberar a cena atual enquanto ela ainda está processando o sinal de colisão — isso gera erro. Por isso uso call_deferred(), que agenda a troca para depois do processamento da física terminar. Além disso, o colisor só reage ao jogador: as camadas de colisão foram nomeadas (Player e Transicao) e a máscara do colisor só detecta a camada do jogador, então nenhum outro corpo dispara a troca.

6. Episódio de depuração

O problema que mais me travou foi a transição da Fase 2 para a salinha: o jogador passava da Fase 1 para a Fase 2 normalmente, mas ao chegar no fim da Fase 2 nada acontecia.

O que eu achava: que o script estava errado ou o sinal não estava conectado. O que era: o campo next_level do colisor estava apontando para um caminho que o script não encontrava — o script monta o caminho como res://scenes/ + next_level + .tscn, então o nome digitado tinha que bater exatamente com o arquivo da salinha dentro da pasta scenes.

Como descobri: rodei o jogo e olhei o erro no console (Output). O Godot mostrava que não conseguia abrir o arquivo da cena, o que apontou direto para o caminho. Corrigi o valor do next_level no Inspetor e a transição passou a funcionar: Fase 1 → Fase 2 → salinha.
