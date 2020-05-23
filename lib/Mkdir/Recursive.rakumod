
unit package Mkdir::Recursive:auth<littlebenlittle>:ver<0.0.0>;

use Log;

my $log = Log::new($?PACKAGE.gist);
$log.subscribe: {
    note  "[" ~ .timestamp.DateTime ~ "]"
         ~ " "  ~ .source
         ~ " "  ~ .level
         ~ ": " ~ .message;
};

#| populate a directory with the given template
our proto populate(|) {*};

multi populate(IO() $path, Baggy:D $template --> Nil) {
    $log.INFO:  "got a Hash: $path";
    $log.INFO:  $template;
    mkdir $path unless $path.d;
    for $template.kv -> $subpath, $content {
        populate $path.add($subpath), $content;
    }
}

multi populate(IO() $path, List:D $template --> Nil) {
    $log.INFO:  "got a List: $path";
    $log.INFO:  $template;
    mkdir $path unless $path.d;
    for $template.kv -> $subpath, $content {
        populate $path.add($subpath), $content;
    }
}

multi populate(IO() $path, Hash:D $template --> Nil) {
    $log.INFO:  "got a Hash: $path";
    $log.INFO:  $template;
    mkdir $path unless $path.d;
    for $template.kv -> $subpath, $content {
        populate $path.add($subpath), $content;
    }
}

multi populate(IO() $path, Pair:D $template --> Nil) {
    $log.INFO:  "got a Pair: $path";
    $log.INFO:  $template.Str;
    mkdir $path unless $path.d;
    my $subpath = $template.key;
    my $content = $template.value;
    populate $path.add($subpath), $content;
}

multi populate(IO() $path, Str:D $content --> Nil) {
    $log.INFO:  "got a Str: $path";
    $log.INFO:  $content;
    die "cowardly choosing not to overwrite existing file: $path" if $path.e;
    $path.spurt($content);
}

multi populate(IO() $path, IO::Path:D $file --> Nil) {
    $log.INFO:  "got a IO::Path: $path";
    die "cowardly choosing not to overwrite existing file: $path" if $path.e;
    die $file.Str ~ " is a directory, not a file"                 if $file.d;
    die "can't copy file that doesn't exist: " ~ $file.Str    unless $file.f;
    my $content = $file.slurp;
    $log.INFO:  $content;
    $path.spurt($content);
}

