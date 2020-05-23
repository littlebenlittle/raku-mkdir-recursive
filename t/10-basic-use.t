use v6;

use Test;
use Mkdir::Recursive;
use TempDir;

plan 2;

subtest "populate a directory" => {
    plan 6;
    ENTER my $dir = TempDir::new;
    LEAVE $dir.rmdir;
    my $structure = {
        'myfile.txt' =>  'hi wo',
        'folder' => {
            'hi' => 'here is some text',
            'wo' => 'and there is more text',
        },
    };
    Mkdir::Recursive::populate($dir, $structure);
    ok $dir.add('myfile.txt').IO.f , "myfile.txt exists";
    ok $dir.add('folder/hi').IO.f  , "hi exists";
    ok $dir.add('folder/wo').IO.f  , "wo exists";
    #
    is $dir.add('myfile.txt').IO.slurp , 'hi wo'                  , "myfile.txt contains 'hi wo'";
    is $dir.add('folder/hi').IO.slurp  , 'here is some text'      , "folder/hi contains 'here is some text'";
    is $dir.add('folder/wo').IO.slurp  , 'and there is more text' , "folder/wo contains 'and there is more text'";
};

subtest "populate a directory with an extisting file" => {
    plan 2;
    ENTER my $dir = TempDir::new;
    LEAVE $dir.rmdir;
    my $structure = {
    'myfile.txt' => $?FILE.IO.dirname.IO.add('fixtures/myfile.txt').IO,
    };
    Mkdir::Recursive::populate($dir, $structure);
    ok $dir.add('myfile.txt').IO.f                         , 'myfile.txt exists';
    is $dir.add('myfile.txt').IO.slurp.chomp , 'some text' , "myfile.txt contains 'hi wo'";
};

done-testing;

