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
	'085D', '0949',	'0935', '091B',	'0870', '0819',	'08AA', '0861',	'08A2', '0942',	'0940', '092A',	'08A9', '088B',	'0963', '08A3',	'08A7', '07EC',	'087F', '091F',	'0961', '0360',	'0436', '0879',	'085E', '095E',	'0921', '089D',	'091C', '094A',	'089B', '086B',	'0882', '0952',	'0894', '088E',	'0958', '0917',	'0966', '023B',	'0364', '0930',	'0948', '0947',	'095D', '0950',	'086D', '0888',	'0877', '087C',	'0920', '0876',	'085C', '088F',	'0936', '0365',	'08A8', '0865',	'087D', '035F',	'088C', '089E',	'08A1', '0866',	'095B', '0898',	'0891', '0969', '02C4', '08AB', '0860', '0887', '0927', '083C', '08AC', '0956', '085B', '0281', '091E', '088D', '0369', '0929', '0862', '094B', '085F', '092C', '0925', '0835', '0869', '0962', '0437', '0946', '0923', '0932', '0366', '094F', '088A', '0953', '0933', '092D', '094D', '087A', '094C', '095A', '08AD', '092F', '0838', '0897', '08A5', '0924', '0438', '0960', '0939', '0875', '0945', '0931', '022D', 
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
