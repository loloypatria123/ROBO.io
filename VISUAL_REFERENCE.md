# 🎨 Visual Reference Card - Dashboard Design System

## Color Palette

### Primary Colors
```
┌─────────────────────────────────────┐
│ Green (Success)                     │
│ #22C55E                             │
│ RGB: 34, 197, 94                    │
│ Usage: Primary actions, success     │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ Blue (Information)                  │
│ #0EA5E9                             │
│ RGB: 14, 165, 233                   │
│ Usage: Info, primary, location      │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ Orange (Warning)                    │
│ #F59E0B                             │
│ RGB: 245, 158, 11                   │
│ Usage: Warnings, caution            │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ Purple (Secondary)                  │
│ #8B5CF6                             │
│ RGB: 139, 92, 246                   │
│ Usage: Secondary actions, returning │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ Red (Error)                         │
│ #EF4444                             │
│ RGB: 239, 68, 68                    │
│ Usage: Errors, danger, stop         │
└─────────────────────────────────────┘
```

### Background Colors
```
┌─────────────────────────────────────┐
│ Dark Navy (Primary Background)      │
│ #020617                             │
│ RGB: 2, 6, 23                       │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ Deep Navy (Secondary Background)    │
│ #0F172A                             │
│ RGB: 15, 23, 42                     │
└─────────────────────────────────────┘
```

---

## Typography System

### Font Family
```
Primary: Poppins (via google_fonts)
Fallback: System font
```

### Font Weights
```
w400 - Regular (body text)
w500 - Medium (labels)
w600 - Semibold (values)
w700 - Bold (headers)
```

### Font Sizes & Usage
```
32px - Main header (Welcome message)
  Weight: w700
  Letter Spacing: -0.5
  Usage: Page title

28px - Status value
  Weight: w700
  Letter Spacing: -0.5
  Usage: Large status display

20px - Stat values
  Weight: w700
  Letter Spacing: -0.3
  Usage: Card values

18px - Section titles
  Weight: w700
  Letter Spacing: -0.3
  Usage: Card headers

15px - Subtitle
  Weight: w400
  Letter Spacing: 0.3
  Usage: Descriptions

14px - Body text
  Weight: w600
  Letter Spacing: -0.2
  Usage: Item values

13px - Labels
  Weight: w500
  Letter Spacing: 0.4
  Usage: Field labels

12px - Small text
  Weight: w500
  Letter Spacing: 0.2
  Usage: Descriptions
```

---

## Spacing Scale

### Padding Standards
```
┌──────────────────────────────────┐
│ Card Padding: 24px all sides     │
│ ┌────────────────────────────┐   │
│ │                            │   │
│ │     Content Area           │   │
│ │                            │   │
│ └────────────────────────────┘   │
└──────────────────────────────────┘

┌──────────────────────────────────┐
│ Section Padding: 20px H, 24px V  │
│ ┌────────────────────────────┐   │
│ │                            │   │
│ │     Content Area           │   │
│ │                            │   │
│ └────────────────────────────┘   │
└──────────────────────────────────┘

┌──────────────────────────────────┐
│ Element Padding: 12-18px         │
│ ┌────────────────────────────┐   │
│ │                            │   │
│ │     Content Area           │   │
│ │                            │   │
│ └────────────────────────────┘   │
└──────────────────────────────────┘
```

### Gap Standards
```
32px - Between major sections
28px - Between card groups
24px - Between cards
18px - Between items
16px - Between rows
12px - Between small items
```

---

## Border Radius

### Sizes
```
24px ─ Large cards (status, activity, sensor)
20px ─ Action buttons
18px ─ Stat cards
14px ─ Icon containers
12px ─ Badges
8px  ─ Small elements
```

### Visual Examples
```
24px Radius:
╭────────────────────────╮
│                        │
│    Large Card          │
│                        │
╰────────────────────────╯

20px Radius:
╭──────────────────╮
│   Button         │
╰──────────────────╯

14px Radius:
╭──────────╮
│ Icon     │
╰──────────╯
```

---

## Shadow System

### Card Shadows
```
Offset:     (0, 8px)
Blur:       25px
Spread:     0px
Color:      Status-dependent with 0.15 alpha

Visual:
┌─────────────────┐
│   Card Content  │
└─────────────────┘
      ▼▼▼▼▼▼▼▼
    (shadow)
```

### Icon Shadows
```
Offset:     (0, 6px)
Blur:       12px
Spread:     0px
Color:      Status-dependent with 0.3 alpha
```

### Subtle Shadows
```
Offset:     (0, 6px)
Blur:       15-18px
Spread:     0px
Color:      White with 0.08-0.12 alpha
```

---

## Animation Timing

### Fade Animation
```
Duration:   600ms
Curve:      linear
Type:       FadeTransition

Timeline:
0ms    ─────────────────────── 600ms
0%     ─────────────────────── 100%
Opacity: 0 ─────────────────── 1
```

### Slide Animation
```
Duration:   800ms
Curve:      easeOutCubic
Type:       SlideTransition

Timeline:
0ms    ─────────────────────── 800ms
0%     ─────────────────────── 100%
Offset: (0, 0.3) ──────────── (0, 0)

Easing Curve:
  │
  │     ╱╱╱
  │   ╱╱
  │ ╱╱
  │╱
  └─────────────
```

---

## Component Specifications

### Status Card
```
┌──────────────────────────────────────┐
│ ┌────┐                               │
│ │ 32 │  Status Title        [BADGE] │
│ │ px │  Large Status Text           │
│ └────┘                               │
│                                      │
│ Progress Bar (if cleaning)           │
│ ████████████░░░░░░░░░░░░░░░░░░░░░░  │
│ 45%                                  │
└──────────────────────────────────────┘
Padding: 24px
Border Radius: 24px
```

### Stat Card
```
┌──────────────────────┐
│ ┌────┐               │
│ │ 22 │               │
│ │ px │               │
│ └────┘               │
│                      │
│ Label                │
│ 20px Value           │
│                      │
└──────────────────────┘
Padding: 18px
Border Radius: 18px
```

### Action Button
```
┌──────────────────────┐
│      ┌────┐          │
│      │ 32 │          │
│      │ px │          │
│      └────┘          │
│                      │
│   Button Label       │
│                      │
└──────────────────────┘
Padding: 14px (icon)
Border Radius: 20px
```

### Activity Item
```
┌────┐
│ 18 │  Label
│ px │  Value
└────┘
Icon Padding: 8px
```

---

## Glassmorphism Effect

### Blur Parameters
```
Sigma X: 10px
Sigma Y: 10px

Visual Effect:
┌─────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░░░░ │  ← Blurred background
│ ░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░ │
└─────────────────────────┘
```

### Gradient Overlay
```
Start:  White with 0.12 alpha (top-left)
End:    White with 0.06 alpha (bottom-right)

Visual:
┌─────────────────────────┐
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │  ← Lighter
│ ░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░ │  ← Darker
└─────────────────────────┘
```

### Border
```
Color:  White with 0.25 alpha
Width:  1.2px

Visual:
┌─────────────────────────┐
│ ╔═════════════════════╗ │  ← Subtle outline
│ ║   Card Content      ║ │
│ ╚═════════════════════╝ │
└─────────────────────────┘
```

---

## Responsive Breakpoints

### Mobile (< 600px)
```
Full width layout
Standard spacing
Touch-optimized
```

### Tablet (600px - 1200px)
```
Slightly increased spacing
Optimized for medium screens
```

### Desktop (> 1200px)
```
Generous spacing
Max-width constraints
Optimized for large screens
```

---

## Color Usage Examples

### Status Indicators
```
Idle:       🔵 Blue (#0EA5E9)
Cleaning:   🟢 Green (#22C55E)
Disposing:  🟠 Orange (#F59E0B)
Returning:  🟣 Purple (#8B5CF6)
Error:      🔴 Red (#EF4444)
```

### UI Elements
```
Primary Action:     🟢 Green (#22C55E)
Secondary Action:   🟣 Purple (#8B5CF6)
Warning:           🟠 Orange (#F59E0B)
Error:             🔴 Red (#EF4444)
Information:       🔵 Blue (#0EA5E9)
```

---

## Typography Hierarchy

### Visual Hierarchy
```
Level 1 (Most Important)
┌─────────────────────────┐
│ 32px, w700, -0.5 spacing│  ← Main header
└─────────────────────────┘

Level 2
┌─────────────────────────┐
│ 18px, w700, -0.3 spacing│  ← Section title
└─────────────────────────┘

Level 3
┌─────────────────────────┐
│ 14px, w600, -0.2 spacing│  ← Value
└─────────────────────────┘

Level 4 (Least Important)
┌─────────────────────────┐
│ 12px, w500, 0.2 spacing │  ← Label
└─────────────────────────┘
```

---

## Quick Reference Grid

### Spacing
```
4px   │ 8px   │ 12px  │ 14px  │ 16px  │ 18px  │ 24px  │ 28px  │ 32px
xs    │ sm    │ md    │ md+   │ lg    │ lg+   │ xl    │ 2xl   │ 3xl
```

### Border Radius
```
8px   │ 12px  │ 14px  │ 18px  │ 20px  │ 24px
sm    │ md    │ md+   │ lg    │ lg+   │ xl
```

### Font Sizes
```
12px  │ 13px  │ 14px  │ 15px  │ 18px  │ 20px  │ 28px  │ 32px
sm    │ sm+   │ base  │ base+ │ lg    │ lg+   │ 2xl   │ 3xl
```

### Font Weights
```
w400  │ w500  │ w600  │ w700
reg   │ med   │ semi  │ bold
```

---

## Design Checklist

### Before Using a Component
- [ ] Check border radius (8-24px)
- [ ] Verify padding (12-24px)
- [ ] Confirm font (Poppins)
- [ ] Check font weight (w400-w700)
- [ ] Verify letter spacing
- [ ] Confirm color from palette
- [ ] Check shadow specifications
- [ ] Verify animation (if applicable)

### Before Deploying
- [ ] All text is Poppins
- [ ] Spacing follows scale
- [ ] Colors from palette
- [ ] Animations smooth
- [ ] No jank or lag
- [ ] Responsive on all sizes
- [ ] Contrast ratios adequate
- [ ] Touch targets adequate

---

## Common Patterns

### Card Pattern
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(24),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.08),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: // Your content
    ),
  ),
)
```

### Animation Pattern
```dart
SlideTransition(
  position: Tween<Offset>(
    begin: const Offset(0, 0.3),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: controller,
    curve: Curves.easeOutCubic,
  )),
  child: // Your widget
)
```

---

## Print-Friendly Reference

### Colors
```
Primary:   #22C55E (Green)
Info:      #0EA5E9 (Blue)
Warning:   #F59E0B (Orange)
Secondary: #8B5CF6 (Purple)
Error:     #EF4444 (Red)
```

### Typography
```
Font:      Poppins
Weights:   400, 500, 600, 700
Sizes:     12, 13, 14, 15, 18, 20, 28, 32px
```

### Spacing
```
Scale:     4, 8, 12, 14, 16, 18, 24, 28, 32px
Padding:   20px H, 24px V
Gaps:      12-32px
```

### Radius
```
Scale:     8, 12, 14, 18, 20, 24px
Cards:     24px
Buttons:   20px
Icons:     14px
```

---

**🎨 Design System Reference Complete! 🎨**

Use this card as a quick reference for all design specifications.
