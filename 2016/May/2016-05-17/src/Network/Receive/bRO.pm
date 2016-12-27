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
	'087B', '08A7', '0884', '0950', '0925', '0878', '0961', '0933', '08A0', '085C', '087E', '0868', '023B', '0940', '08A9', '0947', '0864', '088E', '0436', '0896', '0879', '0366', '0951', '08A6', '085F', '0892', '085E', '0932', '02C4', '093A', '08A4', '0863', '07EC', '0888', '0936', '088B', '0898', '095D', '085D', '089B', '0967', '0838', '093C', '08AB', '0963', '0929', '0894', '095F', '0959', '0802', '088D', '0957', '0941', '0969', '0862', '0874', '0360', '087C', '0866', '0958', '0368', '091B', '089D', '0923', '08A3', '0202', '091D', '089C', '08A8', '095C', '0361', '0960', '0918', '0891', '092B', '085B', '0945', '0364', '08A1', '092C', '093E', '08A5', '0952', '091A', '086F', '0835', '0895', '0890', '094A', '087D', '0919', '0942', '092A', '0927', '095A', '088C', '094F', '0876', '0882', '0943', '0365', '0964', '087A', '0968', '0930', '07E4', '0935', '0817', '092E', '0872', '0953', '0869', '0962', '0920', '0362', '0860', '083C', '089E', '092D', '094D', '0886', '0865', '0928', '035F', '0363', '0949', '0367', '0889', '093B', '0870', '093F', '0281', '0437', '0939', '0926', '0956', '0897', '092F', '0917', '0921', '087F', '0948', '086D', '091C', '08AC', '089A', '0883', '0885', '0873', '0922', '0875', '094B', '0811', '095E', '086B', '0871', '08A2', '0815', '0893', '0880', '08AA', '0819', '0937', '0867', '0438', '0881', '0934', '0887', 
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