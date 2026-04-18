```markdown
# Design System Document: The Editorial Reward Experience

## 1. Overview & Creative North Star: "The Curated Celebration"
This design system moves away from the cluttered, transactional nature of traditional coupon apps. Instead, it treats savings as a premium, curated lifestyle choice. Our Creative North Star is **"The Curated Celebration"**—a digital environment that feels like an upscale boutique rather than a discount warehouse.

To break the "template" look, we employ **Intentional Asymmetry**. We shun rigid, centered grids in favor of dynamic layouts where elements overlap organically. By utilizing high-contrast typography scales—pairing massive, airy headlines with compact, functional labels—we create an editorial rhythm that guides the user’s eye toward "The Win" (the reward).

---

## 2. Colors: Tonal Sophistication
Our palette balances the authority of Indigo with the playful energy of Mint and Pink. We use color not just for decoration, but as a functional tool for hierarchy.

* **Primary (`#5d3fd3`):** Use for high-intent actions and "Trust Anchors."
* **Secondary/Mint (`#006a35`):** Reserved exclusively for "Value Creation"—savings amounts, success states, and earned rewards.
* **Tertiary/Pink (`#993c50`):** Used for "Discovery" and "Urgency"—flash deals or limited-time offers.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders to section content. Boundaries must be defined solely through background color shifts. For instance, a `surface-container-low` section should sit directly on a `surface` background to create a logical break without visual "noise."

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. To define importance:
1. **Base:** `surface` (`#fdf3ff`)
2. **Sectioning:** `surface-container-low` (`#f9edff`)
3. **Interactive Cards:** `surface-container-highest` (`#ebd4ff`)
4. **Floating Elements:** `surface-container-lowest` (`#ffffff`)

### The "Glass & Gradient" Rule
To elevate the "out-of-the-box" feel, use **Glassmorphism** for navigation bars and floating action buttons. Apply a backdrop-blur (16px–24px) to `surface` tokens at 80% opacity.
* **Signature Texture:** Main CTAs should use a linear gradient from `primary` (`#5d3fd3`) to `primary-container` (`#a391ff`) at a 135° angle to add "soul" and depth.

---

## 3. Typography: Editorial Authority
We utilize two distinct typefaces to balance friendliness with clarity.

* **Display & Headlines (Plus Jakarta Sans):** Our "Voice." Large, bold, and expressive. Use `display-lg` for massive savings announcements to create a sense of celebration.
* **Body & Titles (Be Vietnam Pro):** Our "Engine." Highly legible and clean. Use `body-md` for fine print and `title-lg` for merchant names.

The juxtaposition of the rounded, approachable Plus Jakarta Sans with the structural Be Vietnam Pro creates a "High-End Retail" aesthetic that feels both professional and welcoming to the Surat market.

---

## 4. Elevation & Depth: Tonal Layering
We do not use shadows to create "pop"; we use them to create "atmosphere."

* **The Layering Principle:** Depth is achieved by stacking. A `surface-container-lowest` card placed on a `surface-container-low` background creates a natural lift.
* **Ambient Shadows:** For floating elements, use a `24px` blur with `4%` opacity. The shadow color must be a tinted version of `on-surface` (`#38274c`), never pure black.
* **The "Ghost Border":** If a border is required for accessibility, use the `outline-variant` token at **15% opacity**. 100% opaque borders are strictly forbidden.
* **Glassmorphism:** Use semi-transparent `surface-container` colors with `backdrop-filter: blur(20px)` for overlays to ensure the brand's vibrant background colors bleed through, maintaining a cohesive "vibe."

---

## 5. Components: The Physicality of Savings

### Ticket-Style Cards (The Hero Component)
* **Construction:** Use `surface-container-lowest` for the card body.
* **The "Punch-out":** Instead of a line, use a semi-circle mask on the left and right edges with a dashed `outline-variant` (20% opacity) connecting them to mimic a physical coupon.
* **Radius:** Use `lg` (`2rem`) for the outer card and `sm` (`0.5rem`) for inner elements.

### Buttons
* **Primary:** Gradient (`primary` to `primary-container`), `full` radius, `6` (`2rem`) height. No shadow.
* **Secondary:** `surface-container-highest` background with `primary` text. Use for "Save for Later."
* **Tertiary:** Ghost style. No background, `primary` text, `label-md` typography.

### Inputs & Fields
* **Style:** `surface-container-low` background, no border. On focus, transition to a `Ghost Border` using the `primary` color at 20% opacity.
* **Spacing:** `4` (`1.4rem`) internal padding to allow the typography to breathe.

### Forbidding Dividers
**Rule:** Forbid the use of horizontal rules (`
`). Use the Spacing Scale (specifically `8` or `10`) to create "White Space Dividers" or shift the background token to `surface-container-low` to group items.


---

## 6. Do's and Don'ts

### Do:
* **Do** overlap images of products over the edge of their containers (using `z-index` and `xl` radius) to create a sense of tactile depth.
* **Do** use `secondary_container` (`#6bfe9c`) for "Success" moments—it reinforces the "Mint for Savings" psychology.
* **Do** lean into asymmetrical margins. For example, a headline might have a `6` left margin but an `8` right margin to feel more editorial.

### Don't:
* **Don't** use 100% black (`#000000`) for text. Always use `on-surface` (`#38274c`) to maintain the soft, energetic mood.
* **Don't** use sharp corners. Every element, including selection states and tooltips, must use at least a `sm` (`0.5rem`) radius.
* **Don't** crowd the screen. If a user has three coupons, show one and a half to encourage horizontal scrolling (the "Peek" effect), utilizing the `16` spacing scale for the gutters.

---

## 7. Market Context: Surat & Beyond
While the system is modern and "global-premium," the use of the **Indigo/Violet** primary base resonates with the "Trust" required in the Indian financial/rewards sector, while the **Soft Pink** and **Mint** accents reflect the vibrant, celebratory culture of Surat’s textile and diamond hubs. The interface should feel like a high-end mall: spacious, bright, and rewarding.```