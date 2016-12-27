#############################################################################
#  OpenKore - Network subsystem												#
#  This module contains functions for sending messages to the server.		#
#																			#
#  This software is open source, licensed under the GNU General Public		#
#  License, version 2.														#
#  Basically, this means that you're allowed to modify and distribute		#
#  this software. However, if you distribute modified versions, you MUST	#
#  also distribute the source code.											#
#  See http://www.gnu.org/licenses/gpl.html for the full license.			#
#############################################################################
# bRO (Brazil)
package Network::Receive::bRO;
use strict;
use Log qw(warning);
use base 'Network::Receive::ServerType0';

# Sync_Ex algorithm developed by Fr3DBr
sub new {
	my ($class) = @_;
	my $self = $class->SUPER::new(@_);
	
	my %packets = (
		'0097' => ['private_message', 'v Z24 V Z*', [qw(len privMsgUser flag privMsg)]], # -1
	);
	# Sync Ex Reply Array 
	$self->{sync_ex_reply} = {
	'0941', '0951',	'0948', '0959',	'023B', '0874',	'0962', '0881',	'089C', '08A4',	'0943', '08A6',	'08AB', '0363',	'0942', '0919',	'095E', '089B',	'0958', '02C4',	'091D', '0202',	'0868', '0897',	'0935', '0887',	'095B', '0949',	'087D', '0921',	'0882', '087F',	'085D', '0944',	'086D', '0888',	'0437', '0361',	'0964', '0871',	'093C', '08AD',	'022D', '08AC',	'0925', '0364',	'0817', '0933',	'0927', '0931',	'0880', '0369',	'088D', '094C',	'0932', '086A',	'0281', '083C',	'085E', '085A',	'0926', '0920',	'0872', '0918',	'0869', '0362',	'093A', '0967',	'095A', '087A',	'07EC', '089D',	'0866', '0885',	'087B', '0365',	'0893', '0957',	'0899', '0436',	'0937', '094A',	'0366', '0802',	'08A0', '08A3',	'0923', '0819',	'0945', '092C',	'092E', '035F',	'08A1', '0960',	'0940', '0876',	'0930', '0950',	'089F', '0955',	'086F', '095D',	'0966', '093B',	'093D', '0861',	'0367', '0891',	'0934', '0875',	'092B', '087C',	'093E', '089A',	'094E', '0968',	'094B', '0883',	'0892', '0947',	'0936', '0896',	'0889', '0894',	'0863', '0963',	'07E4', '0929',	'0939', '086B',	'0860', '086E',	'085F', '0368',	'08A9', '095F',	'092F', '08A7',	'0969', '088A',	'0953', '086C',	'0890', '0870',	'092A', '092D',	'0928', '0811',	'0877', '0965',	'0867', '0895',	'0946', '089E',	'0862', '0838',	'088C', '0924',	'091F', '0815',	'08A5', '091E',	'096A', '091B',	'091A', '0898',	'08AA', '094D',	
	};
	
	foreach my $key (keys %{$self->{sync_ex_reply}}) { $packets{$key} = ['sync_request_ex']; }
	foreach my $switch (keys %packets) { $self->{packet_list}{$switch} = $packets{$switch}; }
	
	return $self;
}

sub items_nonstackable {
	my ($self, $args) = @_;

	my $items = $self->{nested}->{items_nonstackable};

	if($args->{switch} eq '00A4' || $args->{switch} eq '00A6' || $args->{switch} eq '0122') {
		return $items->{type4};
	} elsif ($args->{switch} eq '0295' || $args->{switch} eq '0296' || $args->{switch} eq '0297') {
		return $items->{type4};
	} elsif ($args->{switch} eq '02D0' || $args->{switch} eq '02D1' || $args->{switch} eq '02D2') {
		return  $items->{type4};
	} else {
		warning("items_nonstackable: unsupported packet ($args->{switch})!\n");
	}
}

*parse_quest_update_mission_hunt = *Network::Receive::ServerType0::parse_quest_update_mission_hunt_v2;
*reconstruct_quest_update_mission_hunt = *Network::Receive::ServerType0::reconstruct_quest_update_mission_hunt_v2;

1;
