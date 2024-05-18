import binascii


samples = bytearray()

# Open in binary mode (so you don't read two byte line endings on Windows as one byte)
# and use with statement (always do this to avoid leaked file descriptors, unflushed files)
with open('handel.raw', 'rb') as f:
    # Slurp the whole file and efficiently convert it to hex all at once
    for data in f.read():
        samples.append(data)


with open('test.txt', 'w') as fout:
    for data in samples:
        fout.write(f"{format(data, '02x')}\n")

   