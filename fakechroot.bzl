def get_fakechroot(files):
    """Extracts the fakechroot binary out of the given files from the label.

    Args:
        files: files from a label
    Returns:
        files required to run the fakechroot
    """
    for f in files:
        if f.basename == "libfakechroot.so":
            return f
    fail("couldn't find libfakechroot.so inside", files)
