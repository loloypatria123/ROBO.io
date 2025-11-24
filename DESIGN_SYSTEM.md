# 🎨 RoboCleaner Dashboard - Design System 2025

## Color Palette

### Primary Colors
```
Green (Success/Action):   #22C55E
Blue (Info/Primary):      #0EA5E9
Orange (Warning):         #F59E0B
Purple (Secondary):       #8B5CF6
Red (Error/Danger):       #EF4444
```

### Background
```
Dark Navy:                #020617
Deep Navy:                #0F172A
```

### Transparency Levels
```
High opacity:             0.12 (12%)
Medium opacity:           0.15-0.18 (15-18%)
Low opacity:              0.25 (25%)
Text opacity:             0.7 (70%)
Subtle opacity:           0.05-0.08 (5-8%)
```

---

## Typography System

### Font Family
```
Primary: Poppins (via google_fonts)
```

### Font Weights & Sizes

#### Headers
```
Size: 32px
Weight: w700 (bold)
Letter Spacing: -0.5
Usage: Main welcome message
```

#### Section Titles
```
Size: 18px
Weight: w700 (bold)
Letter Spacing: -0.3
Usage: Card titles, section headers
```

#### Labels
```
Size: 12-13px
Weight: w500 (medium)
Letter Spacing: 0.2-0.4
Usage: Field labels, descriptions
```

#### Values
```
Size: 14-20px
Weight: w600-w700 (semibold-bold)
Letter Spacing: -0.2 to 0.3
Usage: Status values, metrics
```

#### Body Text
```
Size: 14-15px
Weight: w400-w500 (regular-medium)
Letter Spacing: 0.2-0.3
Usage: Descriptions, content
```

---

## Spacing Scale

```
4px   - xs (minimal gaps)
8px   - sm (small gaps)
12px  - md (medium gaps)
14px  - md+ (medium-large gaps)
16px  - lg (large gaps)
18px  - lg+ (large-plus gaps)
24px  - xl (extra large)
28px  - 2xl (double extra large)
32px  - 3xl (triple extra large)
```

### Padding Standards
```
Cards:      24px all sides
Sections:   20px horizontal, 24px vertical
Elements:   12-18px
Icons:      8-14px
```

### Gap Standards
```
Between cards:      28-32px
Between rows:       16px
Between items:      12-18px
Between sections:   24px
```

---

## Border Radius

```
Large cards:        24px (modern, rounded)
Medium cards:       20px
Small cards:        18px
Icon containers:    14px
Buttons:            20px
Small elements:     8-12px
Status badges:      8px
```

---

## Shadow System

### Card Shadows
```
Offset:     (0, 8px)
Blur:       25px
Spread:     0px
Color:      Status-dependent with 0.15 alpha
Example:    BoxShadow(
              color: statusColor.withValues(alpha: 0.15),
              blurRadius: 25,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            )
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

## Animation System

### Fade Animation
```
Duration:   600ms
Curve:      linear
Type:       FadeTransition
Usage:      Header entrance
```

### Slide Animation
```
Duration:   800ms
Curve:      easeOutCubic
Type:       SlideTransition
Offset:     (0, 0.3) → (0, 0)
Usage:      Card entrance
```

### Timing
```
Staggered:  Each card slides in sequence
Smooth:     easeOutCubic for natural deceleration
Professional: 600-800ms duration
```

---

## Component Specifications

### Status Card
```
Border Radius:  24px
Padding:        24px
Icon Size:      32px
Icon Padding:   14px
Title Size:     28px (w700)
Label Size:     13px (w500)
Progress Bar:   6px height
```

### Stat Cards
```
Border Radius:  18px
Padding:        18px
Icon Size:      22px
Icon Padding:   10px
Label Size:     12px (w500)
Value Size:     20px (w700)
```

### Action Buttons
```
Border Radius:  20px
Padding:        14px (icon container)
Icon Size:      32px
Label Size:     13px (w600)
Spacing:        14px (icon to label)
```

### Activity Items
```
Icon Container: 8px padding, 8px border radius
Icon Size:      18px
Label Size:     12px (w500)
Value Size:     14px (w600)
Spacing:        14px (icon to text)
```

### Sensor Items
```
Label Size:     12px (w500)
Value Size:     14px (w600)
Badge Padding:  12px horizontal, 6px vertical
Badge Radius:   8px
```

---

## Glassmorphism Details

### Blur Effect
```
Sigma X:    8-10px
Sigma Y:    8-10px
Filter:     ImageFilter.blur(sigmaX: X, sigmaY: Y)
```

### Gradient Overlay
```
Start Color:    Colors.white.withValues(alpha: 0.12)
End Color:      Colors.white.withValues(alpha: 0.06)
Direction:      topLeft to bottomRight
```

### Border
```
Color:      Colors.white.withValues(alpha: 0.25)
Width:      1.2px
Effect:     Subtle outline for definition
```

---

## Responsive Breakpoints

```
Mobile:     < 600px
Tablet:     600px - 1200px
Desktop:    > 1200px
```

### Adjustments
```
Mobile:     Standard spacing, full width
Tablet:     Slightly increased spacing
Desktop:    Generous spacing, max-width constraints
```

---

## Color Usage Guidelines

### Status Indicators
```
Idle:       Blue (#0EA5E9)
Cleaning:   Green (#22C55E)
Disposing:  Orange (#F59E0B)
Returning:  Purple (#8B5CF6)
Error:      Red (#EF4444)
```

### UI Elements
```
Primary Actions:    Green (#22C55E)
Secondary Actions:  Purple (#8B5CF6)
Warnings:          Orange (#F59E0B)
Errors:            Red (#EF4444)
Info:              Blue (#0EA5E9)
```

### Backgrounds
```
Main Background:    #020617 to #0F172A gradient
Card Background:    White with 0.06-0.12 alpha
Hover State:        Increase alpha by 0.05
```

---

## Best Practices

### Do's ✅
- Use Poppins font for all text
- Maintain consistent spacing using the scale
- Apply glassmorphism to all cards
- Use smooth animations with easeOutCubic
- Keep shadows subtle and directional
- Use transparency for depth
- Maintain proper contrast ratios

### Don'ts ❌
- Don't mix fonts (use Poppins only)
- Don't use tight spacing (minimum 12px)
- Don't skip animations for cards
- Don't use harsh shadows
- Don't ignore letter spacing
- Don't use opaque backgrounds
- Don't mix border radius sizes randomly

---

## Implementation Example

```dart
// Glasmorphic Card Template
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: // Your content here
    ),
  ),
)
```

---

## Version History

- **v1.0** (2025): Initial professional redesign with glassmorphism, animations, and Poppins typography

---

## Support & Customization

For customizations or updates to this design system, ensure:
1. All changes maintain the color palette
2. Typography follows the weight and spacing guidelines
3. Spacing uses the defined scale
4. Animations use easeOutCubic curve
5. Border radius follows the specifications
6. Shadows remain subtle and directional
