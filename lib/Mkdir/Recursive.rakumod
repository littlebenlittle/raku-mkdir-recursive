
unit package Mkdir::Recursive:auth<littlebenlittle>:ver<0.0.0>;

#|( populate a directory with the given structure

Recursively populate C<$dir> with the given structure.

Strings are interpreted as files, lists are intepreted
as key-value pairs for a sub-directory.
)
our sub populate(IO() $dir, $structure) {
    note "populating $dir";
    mkdir $dir unless $dir.d;
    for $structure.kv -> $name, $content {
        my $path = $dir.add($name).IO;
        if $content.isa(Str) {
            note "emitting to $path";
            $path.spurt($content);
        } else {
            populate($path, $content);
        }
    }
}

