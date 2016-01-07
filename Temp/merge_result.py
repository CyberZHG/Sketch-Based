import os

with open('result.html', 'w') as writer:
    for cat in os.listdir('result'):
        if not os.path.isdir('result/' + cat):
            continue
        writer.write('<h1>' + cat + '</h1>' + '<br>')
        for name in os.listdir('result/' + cat):
            writer.write('<img width=128 height=128 src="result/' + cat + '/' + name + '"" />')
        writer.write('<hr>')
