"""Prompt generation templates for StyleMirror AI pipeline according to docs/04_AI_PIPELINE.md"""

HAIR_ONLY_TEMPLATE = """Edit this photo. Change ONLY the person's hairstyle to: {hair_name} — {hair_hint}.
Keep the exact same face, identity, skin tone, facial features, expression, facial hair,
clothing, background, lighting, and camera angle. Keep hair color natural unless told otherwise.
The result must look like a real, unedited photograph of the same person."""

BEARD_ONLY_TEMPLATE = """Edit this photo. Change ONLY the person's facial hair to: {beard_name} — {beard_hint}.
Keep the exact same face, identity, hairstyle, skin tone, expression, clothing, background,
lighting and camera angle. Beard must match the person's hair color and grow naturally along
the jawline. Photorealistic, no artifacts."""

COMBO_TEMPLATE = """Edit this photo. Change ONLY the hairstyle to {hair_name} ({hair_hint}) and the facial
hair to {beard_name} ({beard_hint}). Keep identity, face shape, skin tone, expression,
clothing, background, lighting and camera angle exactly the same. Photorealistic."""

STRICT_IDENTITY_SUFFIX = """\nThe face MUST remain identical to the input photo. Do not alter eyes, nose, mouth, jawline or skin tone."""

def build_prompt(
    hair_name: str | None = None,
    hair_hint: str | None = None,
    beard_name: str | None = None,
    beard_hint: str | None = None,
    view: str = "front",
    strict: bool = False,
) -> str:
    if hair_name and beard_name:
        prompt = COMBO_TEMPLATE.format(
            hair_name=hair_name,
            hair_hint=hair_hint or "",
            beard_name=beard_name,
            beard_hint=beard_hint or "",
        )
    elif hair_name:
        prompt = HAIR_ONLY_TEMPLATE.format(
            hair_name=hair_name,
            hair_hint=hair_hint or "",
        )
    elif beard_name:
        prompt = BEARD_ONLY_TEMPLATE.format(
            beard_name=beard_name,
            beard_hint=beard_hint or "",
        )
    else:
        prompt = "Enhance lighting and clarity of portrait photo without altering facial identity."

    if view in ("side", "back"):
        prompt += f"\nGenerate the same person with the same hairstyle from the {view} view."

    if strict:
        prompt += STRICT_IDENTITY_SUFFIX

    return prompt.strip()

