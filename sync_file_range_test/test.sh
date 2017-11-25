cd ../sync_file_range_test/
python setup.py build_ext --inplace > setup.log 2> setup.err
python sync_file_range_test.py > test.log 2> test.err
grep "sync_file_range not existent" test.err | tail -n 1 | wc -l

