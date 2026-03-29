# Design System Document: High-End B2B Logistics & Commerce

## 1. Overview & Creative North Star: "The Architectural Ledger"
The goal of this design system is to move beyond the utilitarian "dashboard" look and toward a sophisticated, editorial-grade interface that commands authority. We are building for B2B sellers who manage complex financial data and location-based logistics; they require efficiency, but they deserve an experience that feels premium and intentional.

**Creative North Star: The Architectural Ledger**
This system treats the screen not as a flat canvas, but as a series of structured, physical layers. We reject the "boxed-in" nature of traditional enterprise software. Instead, we use high-contrast typography (The Ledger) and tonal depth (The Architecture) to guide the eye. By utilizing intentional asymmetry and generous whitespace, we create a "Digital Curator" experience—where the most important data (financial logs, coin balances, and scan actions) is elevated, while secondary information recedes into the background architecture.

---

## 2. Colors & Tonal Depth
Our palette is rooted in a deep, trustworthy `primary` (#003461) and a growth-oriented `secondary` (#1b6d24). These are not just colors; they are signals of stability and success.

### The "No-Line" Rule
**Strict Mandate:** Designers are prohibited from using 1px solid borders to define sections. Layouts must be structured using background color shifts or tonal transitions.
- **Example:** A `surface-container-low` section sitting on a `surface` background creates a natural boundary. If you feel the urge to draw a line, increase the padding (using the Spacing Scale) or shift the surface tier instead.

### Surface Hierarchy & Nesting
Treat the UI as a stack of fine paper.
- **Base Layer:** `surface` (#f9f9ff)
- **Content Blocks:** `surface-container-low` (#f3f3f9) for secondary grouping.
- **Elevated Cards:** `surface-container-lowest` (#ffffff) to make critical data "pop" against the slightly darker background.
- **Active Overlays:** `surface-bright` (#f9f9ff) for modals or focused states.

### The "Glass & Gradient" Rule
To elevate the "Scan" and "Coin" interactions:
- **Main CTAs:** Use a subtle linear gradient from `primary` (#003461) to `primary_container` (#004b87) at a 135-degree angle. This adds "soul" and depth.
- **Floating Elements:** Use Glassmorphism for location-based cues or floating scan buttons. Apply `surface_container_lowest` at 70% opacity with a `20px` backdrop blur.

---

## 3. Typography: The Editorial Scale
We use a dual-font strategy to balance character with readability.

* **Display & Headlines (Manrope):** Our "Editorial" voice. Manrope’s geometric yet warm curves provide a modern, high-end feel for totals, city names, and section headers.
* *Headline-LG:* 2rem — Reserved for page titles and major financial summaries.
* **Body & Labels (Inter):** Our "Functional" voice. Inter is used for all tabular data, logs, and "Coin" denominations to ensure maximum legibility at small sizes.
* *Body-MD:* 0.875rem — The workhorse for list items and seller logs.
* *Label-SM:* 0.6875rem — Used for micro-metadata (e.g., timestamps in logs).

---

## 4. Elevation & Depth
Hierarchy is achieved through **Tonal Layering**, not structural lines.

- **The Layering Principle:** Place a `surface-container-lowest` (#ffffff) card on top of a `surface-container-low` (#f3f3f9) section. This creates a soft, sophisticated lift.
- **Ambient Shadows:** For "Scan" buttons or floating action elements, use a highly diffused shadow: `box-shadow: 0 12px 32px rgba(25, 28, 32, 0.06)`. The shadow color must be a tinted version of `on-surface`, never pure black.
- **The "Ghost Border":** If a boundary is required for accessibility (e.g., in a high-density financial table), use the `outline_variant` (#c2c6d1) at **15% opacity**.

---

## 5. Components

### Action Buttons (The 'Scan' Focus)
- **Primary (Scan):** Large (Height: 3.5rem / Spacing 16), utilizing the `primary` gradient. Use `xl` (0.75rem) roundedness.
- **Secondary:** `surface-container-high` background with `on-primary-fixed-variant` text. No border.

### The 'Coin' Element
To distinguish 'Coins' from regular currency:
- **Styling:** Use `tertiary_fixed` (#ffe16d) as a soft background pill with `on-tertiary-fixed` (#221b00) text.
- **Iconography:** Pair with a subtle 85% opacity gold glyph. Use `tertiary_fixed_dim` (#e9c400) for a shimmering gradient effect on the icon itself.

### Data Cards & Financial Lists
- **Rule:** Forbid divider lines.
- **Structure:** Use a `2.5` (0.5rem) spacing gap between list items. Each item should sit on a `surface-container-low` background that shifts to `surface-container-highest` on hover.
- **Location Cues:** For city/area context, use a `label-md` with a subtle vertical accent bar (2px wide) in `secondary` (#1b6d24) to the left of the city name.

### Input Fields
- **Default:** `surface-container-highest` background, `none` border, and `md` roundedness.
- **Focus:** Transition to `primary` (#003461) with a 2px "Ghost Border" (10% opacity).

---

## 6. Do's and Don'ts

### Do
- **Do** use `20` (4.5rem) or `24` (5.5rem) spacing for top-level page margins to create an editorial "gallery" feel.
- **Do** use `secondary` (#1b6d24) sparingly for "Success" states and logistics confirmations.
- **Do** stack `surface` containers to create depth—think of it like layers of architectural vellum.

### Don't
- **Don't** use 1px solid black or grey borders. It breaks the premium "No-Line" aesthetic.
- **Don't** use standard "Drop Shadows." Only use low-opacity Ambient Shadows.
- **Don't** use `primary` for error states. Always use the `error` (#ba1a1a) and `error_container` (#ffdad6) tokens to ensure the seller notices critical failures immediately.
- **Don't** crowd financial logs. If the data is dense, increase the `line-height` rather than adding dividers.