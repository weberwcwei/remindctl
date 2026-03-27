# remindctl

Forget the app, not the task ✅

Fast CLI for Apple Reminders on macOS.

## Install

### Homebrew (Home Pro)
```bash
brew install steipete/tap/remindctl
```

### From source
```bash
pnpm install
pnpm build
# binary at ./bin/remindctl
```

## Development
```bash
make remindctl ARGS="status"   # clean build + run
make check                     # lint + test + coverage gate
```

## Requirements
- macOS 14+ (Sonoma or later)
- Swift 6.2+
- Reminders permission (System Settings → Privacy & Security → Reminders)

## Usage

### View Reminders
```bash
remindctl                      # show today (default)
remindctl today                 # show today
remindctl tomorrow              # show tomorrow
remindctl week                  # show this week
remindctl overdue               # overdue
remindctl upcoming              # upcoming
remindctl completed             # completed
remindctl all                   # all reminders
remindctl 2026-01-03            # specific date
```

### Manage Lists
```bash
remindctl list                  # list all lists
remindctl list Work             # show specific list
remindctl list Projects --create
remindctl list Work --rename Office
remindctl list Work --delete
```

### Add Reminders
```bash
# One positional arg = title (uses default list)
remindctl add "Buy milk"

# Two positional args = list name + title
remindctl add "Personal" "Buy milk"
remindctl add "🤖 Daily Tasks" "Review docs"

# Flags
remindctl add --title "Call mom" --list Personal --due tomorrow
remindctl add "Buy milk" --list Personal --due 2026-01-04 --priority high

# Recurrence
remindctl add "Take vitamins" --due tomorrow --repeat daily
remindctl add "🤖 Life Admin" "Vacuum floors" --due 2026-03-29 --repeat biweekly
```

Do not mix positional list with `--list`, or positional title with `--title`.

### Edit Reminders
```bash
remindctl edit 1 --title "New title"            # by index
remindctl edit 4A83 --due tomorrow              # by ID prefix (4+ chars)
remindctl edit 2 --priority high --notes "ASAP"
remindctl edit 3 --clear-due                    # remove due date
remindctl edit 1 --repeat weekly                # add/change recurrence
remindctl edit 2 --no-repeat                    # remove recurrence
remindctl edit 5 --complete                     # mark done
remindctl edit 3 --incomplete                   # mark not done
remindctl edit 1 --list "Other List"            # move to list
```

### Complete / Delete
```bash
remindctl complete 1 2 3       # complete by index or ID prefix
remindctl delete 4A83 --force  # delete by ID prefix
```

### Permissions
```bash
remindctl status                # permission status
remindctl authorize             # request permissions
```

## Output formats
- `--json` emits JSON arrays/objects.
- `--plain` emits tab-separated lines.
- `--quiet` emits counts only.

## Date formats
Accepted by `--due` and filters:
- `today`, `tomorrow`, `yesterday`
- `YYYY-MM-DD`
- `YYYY-MM-DD HH:mm`
- ISO 8601 (`2026-01-03T12:34:56Z`)

## Recurrence values
Accepted by `--repeat`:
- `daily`, `weekly`, `biweekly`, `monthly`, `yearly`
- Custom: `"every 3 days"`, `"every 2 weeks"`, `"every 6 months"`

Remove with `--no-repeat` (edit only).

## Priority values
Accepted by `--priority`: `none`, `low`, `medium` (or `med`), `high`

## Permissions
Run `remindctl authorize` to trigger the system prompt. If access is denied, enable
Terminal (or remindctl) in System Settings → Privacy & Security → Reminders.
If running over SSH, grant access on the Mac that runs the command.
