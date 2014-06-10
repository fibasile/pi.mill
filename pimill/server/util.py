import os


def get_save_path():
    return '%s/upload' % os.getcwd()

def get_rml_path():
    return '%s/%s' % (get_save_path(), 'image.rml')