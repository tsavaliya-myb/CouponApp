# Design System Specification: The Executive Ledger

## 1. Overview & Creative North Star
This design system is built on the Creative North Star of **"The Architectural Authority."** For a B2B Seller App, we must move beyond the "generic dashboard" look. Instead, we treat financial data with the reverence of a high-end editorial publication. 

The system rejects the standard "box-on-box" grid. We achieve a premium feel through **intentional asymmetry**, high-contrast typography scales (mixing the organic curves of Manrope with the precision of Inter), and a departure from traditional borders in favor of **Tonal Layering**. The result is an interface that feels less like a tool and more like a bespoke command center—structured, trustworthy, and unmistakably professional.

---

## 2. Colors & Surface Philosophy

### The "No-Line" Rule
To maintain an elite, modern aesthetic, **1px solid borders are prohibited for sectioning.** We do not "box" our content. Structure must be defined solely through background color shifts or subtle tonal transitions. For example, a `surface-container-low` section should sit directly on a `surface` background to create a boundary through value, not lines.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers—like stacked sheets of fine, heavy-weight paper.
- **Background (`#fbf8fe`):** The canvas.
- **Surface-Container-Lowest (`#ffffff`):** Reserved for primary interactive cards and data entry points.
- **Surface-Container-High (`#eae7ed`):** Used for sidebar navigation or secondary utility panels to create a recessive depth.

### The "Glass & Gradient" Rule
For floating elements (modals, dropdowns), utilize **Glassmorphism**. Apply `surface` colors at 80% opacity with a `20px` backdrop-blur. 
- **Signature Textures:** Main CTAs should not be flat. Use a subtle linear gradient from `primary` (#000666) to `primary_container` (#1a237e) at a 135-degree angle to provide a "sheen" that conveys depth and importance.

---

## 3. Typography: Editorial Precision
We pair the geometric elegance of **Manrope** for high-level headings with the utilitarian clarity of **Inter** for financial data.

| Role | Token | Font | Size | Intent |
| :--- | :--- | :--- | :--- | :--- |
| **Display** | `display-lg` | Manrope | 3.5rem | Hero metrics and total revenue sums. |
| **Headline** | `headline-md` | Manrope | 1.75rem | Section headers (e.g., "Monthly Redemptions"). |
| **Title** | `title-md` | Inter | 1.125rem | Sub-headings and card titles. |
| **Body** | `body-md` | Inter | 0.875rem | Logs, descriptions, and secondary data. |
| **Label** | `label-sm` | Inter | 0.6875rem | Metadata, timestamps, and micro-copy. |

*Note: All financial figures must use `Inter` with tabular numbering enabled to ensure decimal points align perfectly in logs.*

---

## 4. Elevation & Depth

### The Layering Principle
Depth is achieved by "stacking" the surface-container tiers. Place a `surface-container-lowest` card (white) on a `surface-container-low` section to create a soft, natural lift.

### Ambient Shadows
When a component must float (e.g., a "Create Invoice" FAB), use an extra-diffused shadow:
- **Shadow Token:** `0 12px 32px -4px rgba(27, 27, 31, 0.06)`. 
- The shadow color is a tinted version of `on-surface` at 6%, mimicking natural light rather than a harsh black drop shadow.

### The "Ghost Border" Fallback
If accessibility requires a container edge, use a **Ghost Border**: `outline-variant` (#c6c5d4) at 15% opacity. Standard 100% opaque borders are strictly forbidden.

---

## 5. Components

### Prominent Action Buttons
- **Primary:** Gradient fill (`primary` to `primary_container`). `xl` (1.5rem) rounded corners. Text is `on_primary` (#ffffff).
- **Secondary:** Surface-tinted. Background `primary_fixed`, text `on_primary_fixed_variant`. No border.

### Data Visualizations & Progress
- **Progress Bars:** Background is `outline_variant` at 20% opacity. The fill uses `secondary` (#1b6d24) for success or `tertiary_container` (#532100) for pending.
- **Mini-Charts:** Lines must be `primary` with a thickness of 2px. Fill areas should use a gradient fading from `primary_fixed` to transparent.

### Logs & List Items
- **Structure:** Forbid divider lines. Use `spacing-4` (0.9rem) of vertical white space to separate items.
- **Status Indicators:** Use `secondary_container` for "Redeemed" and `tertiary_fixed` for "Pending" as soft-filled background chips with high-contrast text.

### High-End Inputs
- **Field Style:** Use `surface_container_highest` with a bottom-only "active" indicator in `primary` (2px). The container should have `DEFAULT` (0.5rem) rounded top corners to feel integrated with the architectural layout.

---

## 6. Do’s and Don’ts

### Do
- **Do** use `spacing-12` and `spacing-16` for "white space as a separator." Give the financial data room to breathe.
- **Do** use `secondary_fixed` for success states; it provides a more premium, muted look than a standard vibrant green.
- **Do** align all text to a baseline grid to maintain the editorial "structured" feel.

### Don't
- **Don't** use standard black (#000000) for text. Always use `on_surface` (#1b1b1f) for better optical comfort.
- **Don't** use `none` roundedness. Even "sharp" elements should have at least `sm` (0.25rem) corners to avoid a dated, "Windows 95" feel.
- **Don't** overlay text on complex textures. If using a background gradient, ensure the `on_primary` contrast ratio is at least 4.5:1.