# Dthr Clock

Pacote Flutter para sincronizar e manter um relógio(s) local(is) baseado(s) na data/hora de uma API externa, com compensação de latência.

Totalmente autônomo em duas modalidades:

- Sincronia chamado dentro do plugin:
  - Necessario fornecer a URL da API + tempo do periodo entre sincronias.
- Sincronia externa (dentro do proprio) app:
  - Necessario fornecer ao app o timestamp atualizado toda vez que for atualizado, atraves dos metodos:
    - clock.getTime()
    - clocksHandler.updateClockTimeStampById()

Funciona em:
Primeiro plano: ✅
Segundo plano: ✅
App fechado: ❌
Offline: ☑️ (Desde que ao inicar o app tenha conexao para buscar timestamp inicial)

## 🪝 Keep on mind

O timestamp precisa ser atualizado toda vez que o app iniciar, portanto, o device precisa de conexao pelo menos em um primeiro instante para buscar o timestamp do servidor.
Se nao houver conexao e o plugin nao tiver conseguido buscar o clock da API o metodo `clock.getTime()` ira lancar excecao ate conseguir.

## ✨ Recursos

- Sincroniza a DTHR com a API automaticamente periodicamente (parametrizavel)
- Compensa a latência de rede.

## 🚀 Instalação

Siga os seguintes passos.

- Baixe o codigo fonte;
- Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  my_dthr_clock:
    path: ../my_dthr_clock
```

## 🧪 Exemplo de uso

```dart
setupAppClock(
  /// segundo parametro indica o intervalo de atualizacao em 
  Settings('http://your.server/api/dthr', 15),
);
final DateTime? now = await clock.getTime();
bool no_initial_connection = now == null;
if(no_initial_connection){
  print('it seems that there was no connection when app started, package will keep trying to fetch server timestamp');
} else {
  print("DTHR atual: \$now");
}
```

## 📦 API esperada

A URL deve retornar JSON:

```json
{
  "dthr": "2025-05-21T15:00:00Z"
}
```

## 📄 Licença

MIT
