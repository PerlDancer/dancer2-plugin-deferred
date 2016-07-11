requires "Dancer2::Plugin" => "0.200000";
requires "URI" => "0";
requires "URI::QueryParam" => "0";
requires "perl" => "5.010";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Dancer2" => "0";
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "HTTP::Cookies" => "0";
  requires "HTTP::Request::Common" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Plack::Test" => "0";
  requires "Test::More" => "0.96";
  requires "perl" => "5.010";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Test::More" => "0.96";
  requires "Test::PAUSE::Permissions" => "0";
  requires "Test::Vars" => "0";
};
