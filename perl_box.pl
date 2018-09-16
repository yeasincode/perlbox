#!/usr/bin/perl -w

sub rootPath{
    my $path=__FILE__;
    $path=~s/perl_box\.pl//;
    $path=~s/\\/\//g;
    $path; 
}

BEGIN{
	unshift @INC,rootPath.'lib';
}

use v5.18.0;
use Encode;
use Tk;
use Tk::MsgBox;
use Path::Class;
use Invoke;

my %fileMaps=();
my $inputStr="输入：";
my $outputStr="输出：";
my $processStr="确定";
my $mainTitle="脚本盒子";
Encode::_utf8_on($inputStr);
Encode::_utf8_on($outputStr);
Encode::_utf8_on($processStr);
Encode::_utf8_on($mainTitle);

my $main = MainWindow->new(-padx=>10,-pady=>10);
$main->title($mainTitle);
my $listbox=$main->Listbox(-width=>30);
my $labelInput=$main->Label(-text=>$inputStr);
my $textInput=$main->Text;
my $labelOutput=$main->Label(-text=>$outputStr);
my $textOutput=$main->Text;
my $btnProcess=$main->Button(-text=>$processStr,-width=>20,-command=>sub {
		onBtnProcessClick($textInput,$textOutput,$listbox);
	});

$listbox->grid(-row=>2,-column=>5,-columnspan=>1,-rowspan=>5,-sticky=>'ns');
$labelInput->grid(-row=>2,-column=>0,-columnspan=>1);
$textInput->grid(-row=>3,-column=>1,-columnspan=>4);
$labelOutput->grid(-row=>4,-column=>0,-columnspan=>1);
$textOutput->grid(-row=>5,-column=>1,-columnspan=>4);
$btnProcess->grid(-row=>6,-column=>4,-columnspan=>1);

&loadFiles;

my @list = keys %fileMaps;
$listbox->insert('end', sort @list );
$listbox->selectionSet(0);
MainLoop;

#按确定时处理
sub onBtnProcessClick{
	my ($textInput,$textOutput,$listbox)=@_;
	my $text=$textInput->Contents;
	my $value= $listbox->get($listbox->curselection);
	if(!$text){
		&show('none input!');
		return;
	}
	elsif(!$value){
		&show('none select!');
		return;
	}

	my $filepath=$fileMaps{$value};
	my $result=Invoke->new($filepath,$value)->execute($text);
	if(!$result){
		&show('none result!');	
		return;
	}
	$textOutput->Contents($result);
}

sub loadFiles{
	my $dir=dir(rootPath.'scripts');
	while(my $file=$dir->next){
		my $fileName=$file;
		next if($file->is_dir||$fileName!~/\.pm$/);
		$fileName=~s/^.+[\/\\]//;
		$fileName=~s/\.pm//;
		$fileMaps{$fileName}=$file->absolute;
	}
}


sub show{
	my $msg=shift;
	my $msgbox=$main->MsgBox(-title=>'Tips',-type=>'ok',-message=>$msg);
	$msgbox->Show;
}
