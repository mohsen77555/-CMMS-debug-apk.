from pathlib import Path

paths = list(Path.home().glob('.pub-cache/hosted/pub.dev/jni-*/android/build.gradle'))
if not paths:
    raise SystemExit('JNI Android Gradle file was not found')

for path in paths:
    lines = path.read_text(encoding='utf-8').splitlines(keepends=True)
    output: list[str] = []
    skipping = False
    depth = 0
    removed = False

    for line in lines:
        stripped = line.strip()
        if not skipping and stripped.startswith('kotlin') and '{' in stripped:
            skipping = True
            depth = line.count('{') - line.count('}')
            removed = True
            if depth <= 0:
                skipping = False
            continue

        if skipping:
            depth += line.count('{') - line.count('}')
            if depth <= 0:
                skipping = False
            continue

        output.append(line)

    if removed:
        path.write_text(''.join(output), encoding='utf-8')
        print(f'Removed incompatible Kotlin block from {path}')
    else:
        print(f'JNI Kotlin block already compatible in {path}')
