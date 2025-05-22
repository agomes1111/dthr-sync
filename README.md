# My DTHR Clock

Pacote Flutter para sincronizar e manter um relógio local baseado na data/hora de uma API externa, com fallback persistente e compensação de latência. Totalmente autônomo: basta fornecer a URL da API.

## ✨ Recursos
- Sincroniza a DTHR com a API automaticamente.
- Compensa a latência de rede.
- Armazena localmente para funcionar offline.
- Re-sincroniza periodicamente.

## 🚀 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  my_dthr_clock:
    path: ../my_dthr_clock
```

## 🧪 Exemplo de uso
```dart
final clock = DthrService('https://example.com/api/dthr');
await clock.initialize();
final now = await clock.getCurrentDthr();
print("DTHR atual: \$now");
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