---
type: debug
tags: [debug, {{language}}, {{symptom-tag}}]
created: {{date}}
project: {{project}}
severity: critical|high|medium|low
---

# {{Bug Title}}

## Symptom
> What the error looked/behaved like. Include exact error message if any.

```
{{error message or stack trace snippet}}
```

## Root Cause
> The actual reason it happened. Be specific — not "null pointer" but WHY was it null.

## Fix

```{{language}}
// Before
{{broken code}}

// After
{{fixed code}}
```

## Why This Works
> The insight that makes the fix correct.

## How to Detect Early
> Linting rule, test, or guard that prevents this in future.

## References
- Project: {{project}}
- Date: {{date}}
