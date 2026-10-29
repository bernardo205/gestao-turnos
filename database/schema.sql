-- Esquema inicial e provisório. Não contém dados nem cria uma base de dados.
-- shortcut: datas e horas são texto ISO 8601 em formato canónico; validar entradas na aplicação antes de persistir.
-- Reforçar a validação no esquema se houver outras fontes de escrita.
PRAGMA foreign_keys = ON;

CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    employee_number TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    hire_date TEXT,
    employment_type TEXT NOT NULL CHECK (employment_type IN ('part_time', 'full_time')),
    weekly_contract_hours REAL CHECK (weekly_contract_hours IS NULL OR weekly_contract_hours >= 0),
    active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1))
);

CREATE TABLE workstations (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1))
);

CREATE TABLE training_assessments (
    id INTEGER PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES employees(id),
    workstation_id INTEGER NOT NULL REFERENCES workstations(id),
    trainer_employee_id INTEGER NOT NULL REFERENCES employees(id),
    assessed_at TEXT NOT NULL,
    result TEXT NOT NULL CHECK (result IN ('pass', 'fail')),
    notes TEXT
);

CREATE TABLE schedules (
    id INTEGER PRIMARY KEY,
    starts_on TEXT NOT NULL,
    ends_on TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published')),
    created_by INTEGER NOT NULL REFERENCES employees(id),
    created_at TEXT NOT NULL,
    published_at TEXT,
    CHECK (starts_on <= ends_on)
);

CREATE TABLE shifts (
    id INTEGER PRIMARY KEY,
    schedule_id INTEGER NOT NULL REFERENCES schedules(id),
    employee_id INTEGER NOT NULL REFERENCES employees(id),
    workstation_id INTEGER NOT NULL REFERENCES workstations(id),
    starts_at TEXT NOT NULL,
    ends_at TEXT NOT NULL,
    break_starts_at TEXT,
    break_ends_at TEXT,
    CHECK (starts_at < ends_at),
    CHECK ((break_starts_at IS NULL AND break_ends_at IS NULL) OR
           (break_starts_at IS NOT NULL AND break_ends_at IS NOT NULL AND
            starts_at <= break_starts_at AND break_starts_at < break_ends_at AND
            break_ends_at <= ends_at))
);

CREATE TABLE time_off_requests (
    id INTEGER PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES employees(id),
    kind TEXT NOT NULL CHECK (kind IN ('day_off', 'absence', 'vacation')),
    starts_on TEXT NOT NULL,
    ends_on TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    requested_at TEXT NOT NULL,
    decided_by INTEGER REFERENCES employees(id),
    decided_at TEXT,
    CHECK (starts_on <= ends_on)
);

CREATE TABLE change_history (
    id INTEGER PRIMARY KEY,
    entity_type TEXT NOT NULL,
    entity_id INTEGER NOT NULL,
    action TEXT NOT NULL,
    changed_by INTEGER NOT NULL REFERENCES employees(id),
    changed_at TEXT NOT NULL,
    before_data TEXT,
    after_data TEXT
);

CREATE INDEX idx_training_employee_workstation_date
    ON training_assessments(employee_id, workstation_id, assessed_at);
CREATE INDEX idx_shifts_schedule_employee
    ON shifts(schedule_id, employee_id);
CREATE INDEX idx_time_off_employee_dates
    ON time_off_requests(employee_id, starts_on, ends_on);
CREATE INDEX idx_change_history_entity
    ON change_history(entity_type, entity_id, changed_at);
