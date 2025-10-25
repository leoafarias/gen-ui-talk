# Gemini Models Reference (Vertex AI)

## Latest Models (2025)

### Gemini 2.5 Flash (GA) - **RECOMMENDED DEFAULT**
- **Model ID:** `gemini-2.5-flash`
- **Status:** Generally Available (GA) - June 17, 2025
- **Use For:** High-throughput enterprise tasks, responsive chat, efficient data extraction
- **Features:**
  - ✓ Thinking capabilities
  - ✓ Fast response times
  - ✓ Best price/performance ratio
  - ✓ Tool calling support
  - ✓ Multimodal input
  - ✓ 1M token context window
- **Pricing:** Most cost-efficient option

### Gemini 2.5 Pro (GA)
- **Model ID:** `gemini-2.5-pro`
- **Status:** Generally Available (GA) - June 17, 2025
- **Use For:** Complex reasoning, advanced code generation, deep multimodal understanding
- **Features:**
  - ✓ Advanced reasoning capabilities
  - ✓ Best for complex tasks
  - ✓ Advanced code generation
  - ✓ Multimodal understanding
  - ✓ Tool calling support
- **Pricing:** Higher cost than Flash

### Gemini 2.5 Flash-Lite (Preview)
- **Model ID:** `gemini-2.5-flash-lite`
- **Status:** Public Preview
- **Use For:** Low latency use cases, cost-sensitive applications
- **Features:**
  - ✓ Fastest model in 2.5 family
  - ✓ Most cost-efficient
  - ✓ Adaptive thinking budgets
  - ✓ Grounding with Google Search
  - ✓ 1M token context window
- **Pricing:** Lowest cost option

## Preview/Experimental Models

### Gemini 2.5 Flash Preview (September 2025)
- **Model ID:** `gemini-2.5-flash-preview-09-2025`
- **Status:** Public Preview
- **Use For:** Testing newest features before GA
- **Note:** Lacks supervised fine-tuning and batch prediction

## Model Selection Guide

### Choose **Gemini 2.5 Flash** when:
- ✓ Building chat applications
- ✓ Need fast response times
- ✓ Working with tools/function calling
- ✓ Cost is a consideration
- ✓ **THIS IS OUR DEFAULT FOR ALL EXAMPLES**

### Choose **Gemini 2.5 Pro** when:
- Complex multi-step reasoning required
- Advanced code generation needed
- Deep analysis of large datasets
- Quality > Speed

### Choose **Gemini 2.5 Flash-Lite** when:
- Ultra-low latency is critical
- Cost optimization is priority
- Simple tasks

## Usage in Flutter Examples

### Default Configuration (All Examples)
```dart
_aiClient = FirebaseAiClient(
  model: 'gemini-2.5-flash',  // Our standard default
  tools: tools,
  systemInstruction: _systemPrompt,
);
```

### For Complex Tasks (Optional)
```dart
_aiClient = FirebaseAiClient(
  model: 'gemini-2.5-pro',  // Use for complex reasoning
  tools: tools,
  systemInstruction: _systemPrompt,
);
```

## Migration from Older Models

### Deprecated Models to Replace:
- `gemini-1.5-flash` → `gemini-2.5-flash`
- `gemini-1.5-pro` → `gemini-2.5-pro`
- `gemini-1.0-pro` → `gemini-2.5-flash`

## Resources

- [Gemini 2.5 Flash Docs](https://cloud.google.com/vertex-ai/generative-ai/docs/models/gemini/2-5-flash)
- [Gemini 2.5 Pro Docs](https://cloud.google.com/vertex-ai/generative-ai/docs/models/gemini/2-5-pro)
- [Vertex AI Model Garden](https://console.cloud.google.com/vertex-ai/publishers/google/model-garden)

---

**Last Updated:** October 24, 2025
**Default Model:** `gemini-2.5-flash`
