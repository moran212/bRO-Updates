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
	'088D', '0963', '0917', '091E', '095B', '0930', '0887', '0864', '092A', '0360', '088F', '096A', '091A', '08A6', '0928', '0936', '0870', '08AB', '092C', '0956', '086D', '089A', '083C', '0937', '08A7', '0861', '0942', '0883', '022D', '08A0', '0962', '0860', '02C4', '0939', '08AD', '092D', '07E4', '086F', '089E', '0946', '0896', '087A', '0881', '08A5', '092B', '0871', '0924', '091D', '0880', '0436', '07EC', '0884', '0954', '0919', '0202', '085E', '091B', '0369', '0888', '0922', '085B', '092F', '0895', '089C', '095E', '0364', '0838', '08A3', '0960', '08A2', '0940', '0933', '08AC', '089F', '0889', '094B', '0894', '0964', '0932', '0865', '0438', '093F', '0365', '0966', '0815', '093A', '085C', '0897', '091F', '085D', '087F', '023B', '0863', '0892', '0918', '0959', '0947', '094C', '0961', '086B', '093E', '0437', '0965', '0873', '035F', '0868', '087D', '087C', '0968', '0811', '0934', '094A', '0872', '095F', '088C', '093C', '0835', '093D', '0948', '0899', '0891', '0943', '0967', '089B', '0927', '0950', '0931', '087E', '0867', '0866', '086E', '0879', '0878', '094E', '0817', '088E', '085F', '0958', '095C', '0953', '0920', '095A', '094D', '0925', '0368', '0923', '0957', '0898', '0893', '095D', '08A1', '0882', '08A9', '0952', '0945', '0876', '0802', '0926', '086C', '0875', '08AA', '0367', '085A', '0921', '0941', '089D', '0929', '088B', 
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