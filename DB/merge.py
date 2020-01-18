filenames = [
    'PUBify.sql',
    'views.sql',
    'procedures.sql',
    'triggers.sql',
    'SEEDify.sql'
]
with open('script.sql', 'w') as outfile:
    for fname in filenames:
        with open(fname) as infile:
            for line in infile:
                outfile.write(line)