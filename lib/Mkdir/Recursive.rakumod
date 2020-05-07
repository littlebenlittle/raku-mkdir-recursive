
unit package Mkdir::Recursive:auth<littlebenlittle>:ver<0.0.0>;

#|( populate a directory with the given structure

Recursively populate C<$dir> with the given structure.

Strings are interpreted as raw text to spurt to files,
lists are intepreted as key-value pairs for a
sub-directory, and IO::Path objects are interpeted
as an existing file whose content is be copied
)
our sub populate(IO() $dir, $structure) {
    mkdir $dir unless $dir.d;
    for $structure.kv -> $name, $content {
        my $path = $dir.add($name).IO;
        given $content {
            when .isa(Str)      { $path.spurt($content)       }
            when .isa(IO::Path) { $path.spurt($content.slurp) }
            when .isa(Hash)     { populate($path, $content);  }
            default             { die "content must be Str, IO, or List; got " ~ .^name }
        }
    }
}

