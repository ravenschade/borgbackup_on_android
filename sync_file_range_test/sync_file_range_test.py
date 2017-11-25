try:
    import sync_file_range_test
except ImportError:
    raise ImportError('sync_file_range not existent')

sync_file_range_test.sync_file_range_test(0)
