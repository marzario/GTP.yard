# This script updates all dependencies in pubspec.yaml to their latest versions from pub.dev.
import yaml
import requests
import re

PUBSPEC_PATH = 'pubspec.yaml'

# Read pubspec.yaml
def read_pubspec():
    with open(PUBSPEC_PATH, 'r', encoding='utf-8') as f:
        return yaml.safe_load(f)

def get_latest_version(package):
    url = f'https://pub.dev/api/packages/{package}'
    r = requests.get(url)
    if r.status_code == 200:
        data = r.json()
        return data['latest']['version']
    return None

def update_versions(pubspec):
    for section in ['dependencies', 'dev_dependencies']:
        if section in pubspec:
            for pkg in pubspec[section]:
                if pkg == 'flutter' or pkg == 'sdk':
                    continue
                latest = get_latest_version(pkg)
                if latest:
                    pubspec[section][pkg] = f'^{latest}'
    return pubspec

def write_pubspec(pubspec):
    with open(PUBSPEC_PATH, 'w', encoding='utf-8') as f:
        yaml.dump(pubspec, f, sort_keys=False, allow_unicode=True)

def main():
    pubspec = read_pubspec()
    pubspec = update_versions(pubspec)
    write_pubspec(pubspec)
    print('pubspec.yaml updated to latest versions.')

if __name__ == '__main__':
    main()
