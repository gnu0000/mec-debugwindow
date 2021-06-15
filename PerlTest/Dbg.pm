#!c:/Perl/bin/perl.exe
#
# Dbg.pm
# Module for logging to a windows window
# Craig Fitz
#
# currently works with 
#   ActiveState Perl 5.10
#
# currently doewsn't work with 
#   ActiveState Perl 5.24
#   ActiveState Strawberry Perl
#

package Dbg;
require Exporter;
use strict;
use Win32::API;

our $VERSION = 0.01;
our @ISA     = qw(Exporter);
our @EXPORT  = qw(Dbg);

sub Dbg
   {
   my ($Message) = @_;

   $Message .= '\0';
   my $FindWindow  = new Win32::API("user32", "FindWindow",  "IP"  , "I");
   my $SendMessage = new Win32::API("user32", "SendMessage", "IIPP", "I");

#print "Dbg.pm debug: FindWindow  = ", $FindWindow  || "(undef)", "\n";
#print "Dbg.pm debug: SendMessage = ", $SendMessage || "(undef)", "\n";


   return 0 if (!$FindWindow || !$SendMessage);

   my $hWnd = $FindWindow->Call (0, "Debug Window") or return 0;

#print "Dbg.pm debug: hWnd        = ", $hWnd  || "(undef)", "\n";

   my $WM_COPYDATA = 0x004a;
   my $MessageLen = length $Message;
   my $cpData = pack ("IIp", 1, $MessageLen, $Message);
   my $Result = $SendMessage->Call ($hWnd, $WM_COPYDATA, 0, $cpData);

   return 1;
   }

1;
