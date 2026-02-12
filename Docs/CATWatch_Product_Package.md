# CATWatch Product Package

## 1) PRODUCT SPEC

### Screens and navigation (iPhone-only)
- **Root**: Tab bar with Map, Feed, Watchlist, Tools, Profile.
- **Map**: Live incident map with severity-coded pins and tap-to-open incident detail sheet.
- **Feed**: Chronological list with filter controls (hazard type + severity now; distance/my zones reserved for V1).
- **Watchlist**: Saved incidents and (V1) saved zones.
- **Tools**: CAT Checklist + quick adjuster workflow actions.
- **Profile**: Permissions, alert settings, stale-data status, privacy/settings placeholders.
- **Incident Detail Sheet**: Key facts + actions (Save, Share brief, Navigate, Add note, Add to checklist).

### User flows
1. **Monitor now**
   - Open app → Map or Feed → scan severity + location quickly.
2. **Get alerted**
   - Open Profile/Alerts → define alert rules (hazard, severity, zone/radius, quiet hours) → local notifications triggered by rules engine.
3. **Act quickly**
   - Select incident → Save to watchlist and start checklist/note.
   - Share brief and launch Apple Maps navigation.
4. **Offline continuity**
   - If refresh fails, show cached records + stale-state indicator + last successful update timestamp.

### MVP vs V1
- **MVP**
  - Tab architecture, MapKit pins, feed filters, watchlist save state.
  - SwiftData local cache for incidents/checklist/notes/zones/rules models.
  - Mock bundled JSON via pluggable source adapter path.
  - Local notification foundation and explicit “background limitations” notes.
- **V1**
  - Live API adapters with auth and retry.
  - Distance + My Zones feed filters and geofencing.
  - Full alert rules UI and notifications scheduling engine.
  - Rich incident sharing template, route ETA prefill, and checklist presets by catastrophe type.

### Data models
- **Incident**: normalized catastrophe event with type, severity, lat/long, area, source, timestamps, details, saved-state.
- **Zone**: user-defined monitoring target with center coordinates and radius.
- **AlertRule**: hazard filter set + severity floor + quiet hours + enabled state.
- **ChecklistItem**: editable deploy action with completion state and optional incident linkage.
- **Note**: offline quick note text linked to incident.
- **Source** (protocol-level concept): adapter identity + provenance label; normalized into Incident.

## 2) DESIGN SYSTEM (white liquid platinum + red glow)

### Tokens
- **Color**
  - Base: system background (`.systemBackground`) for “white liquid platinum”.
  - Layer: translucent white fill + Apple materials (`.regularMaterial`, `.ultraThinMaterial`).
  - Accent: deep red glow (`#DB2738` style) with low-opacity shadow overlays.
- **Spacing**: 4 / 8 / 12 / 16 / 24.
- **Corner radius**: chip 10, button 14, card 18.
- **Type scale**
  - Title3 bold for incident titles.
  - Headline for primary actions.
  - Subheadline / caption for metadata.
- **Material usage**
  - Cards: `.regularMaterial` with fine white stroke.
  - Floating controls: `.thinMaterial` or `.ultraThinMaterial`.

### Components
- `GlassCard`: reusable translucent container with border and round corners.
- `GlowAccent`: modifier creating subtle dual red soft-shadow glow.
- `SeverityBadge`: compact capsule tag for low/medium/high.
- `PrimaryButton`: full-width glass button with optional SF Symbol and red-edge stroke.
- `IncidentRow`: scannable list row combining title, hazard/location, update time, severity.

### Apple-like motion guidelines
- Use **short, easeInOut animations** (0.18–0.28s) for state transitions.
- Prefer **content transitions** and sheet detents over large transforms.
- Avoid flashy looping animations; only signal urgency with mild glow/intensity pulse where needed.
- Preserve perceived stability: map movement user-driven; detail appears as sheet, not full context swap.

## 3) IMPLEMENTATION PLAN (Codex-ready)

### Phase 0: Project setup + signing-ready config
1. Create iOS 17 SwiftUI app target `CATWatch` with iPhone-only deployment.
   - **Done criteria**: App launches on iPhone simulator and physical test device.
2. Add folder architecture and base modules.
   - **Done criteria**: `App/ Features/ Models/ Services/ Persistence/ DesignSystem/ Resources/ Scripts/` represented in Xcode groups.
3. Add Info.plist privacy keys (location + notifications).
   - **Done criteria**: Permission prompts display correctly and app explains usage.
4. Configure signing defaults and bundle identifier placeholders.
   - **Done criteria**: “Automatically manage signing” active and Team selected.

### Phase 1: UI shell + mock data + persistence
1. Build tab shell and core screens.
   - **Done criteria**: All five tabs render and navigate.
2. Implement normalized models with SwiftData.
   - **Done criteria**: Local create/read/write for incidents/checklists/notes.
3. Implement mock source loader using bundled JSON.
   - **Done criteria**: 8–12 incidents decode and display in Map + Feed.
4. Add repository for refresh + cache fallback + stale-state.
   - **Done criteria**: Refresh updates last-updated timestamp; fallback loads cached entries on failures.

### Phase 2: Alerts + zones + rules engine
1. Build alert rule CRUD UI.
   - **Done criteria**: User can create/edit/disable rules with hazard + severity + quiet hours.
2. Implement simple rule evaluator against incoming incidents.
   - **Done criteria**: Matching incidents generate in-app/local notification payloads.
3. Add zone management + feed filtering for “My Zones”.
   - **Done criteria**: Incidents can be filtered by saved zone radius.
4. Add background refresh strategy notes and constraints UI.
   - **Done criteria**: App clearly communicates iOS background delivery limits.

### Phase 3: Polish + accessibility + performance + App Store readiness
1. Accessibility pass (Dynamic Type, VoiceOver, contrast).
   - **Done criteria**: Core flows complete with VoiceOver labels and large text sizes.
2. Performance tuning for map/list updates.
   - **Done criteria**: Smooth scrolling and map interactions with 200+ incidents.
3. QA + release checklist.
   - **Done criteria**: No crashes in smoke tests, offline mode verified, permissions tested.
4. Store metadata + privacy nutrition prep.
   - **Done criteria**: App Privacy details and screenshots prepared for submission.

## 5) DEPLOYMENT RUNBOOK (TestFlight + App Store)

### A. Bundle ID + version/build
1. Open project in Xcode.
2. Select app target **CATWatch** → **General**.
3. Set:
   - Bundle Identifier: `com.yourcompany.CATWatch`
   - Version: semantic release number (e.g., `1.0.0`)
   - Build: incrementing integer (e.g., `1`, `2`, `3`)
4. Confirm deployment target iOS 17+ and iPhone-only device family.

### B. Signing setup
1. Go to **Signing & Capabilities**.
2. Check **Automatically manage signing**.
3. Select your Apple Developer Team.
4. Ensure capability set includes push/local notifications if needed.

### C. Archive + upload
1. Select **Any iOS Device (arm64)** in scheme selector.
2. `Product` → `Archive`.
3. In Organizer, choose latest archive → `Distribute App`.
4. Choose `App Store Connect` → `Upload`.
5. Keep default symbol upload/options unless your org requires custom settings.
6. Complete upload and wait for processing in App Store Connect.

### D. Add internal testers
1. In App Store Connect, open your app → `TestFlight`.
2. Under Internal Testing, create/select an internal group.
3. Add users from your App Store Connect team.
4. Assign latest build and notify testers.

### E. Common errors + fixes
- **Signing certificate/profile missing**: Re-select Team, enable automatic signing, clean build folder.
- **Bundle ID already used**: Change to globally unique identifier.
- **Build rejected for missing privacy strings**: Add required `NSLocationWhenInUseUsageDescription` and notification permission rationale messaging.
- **Upload fails with version/build conflict**: Increment build number and re-archive.
- **Processing delay in TestFlight**: Wait; if >1 hour, re-check export compliance and encryption fields.
