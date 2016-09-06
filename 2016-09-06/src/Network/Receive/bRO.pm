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
	'0860', '0366', '0363', '08A4', '091A', '0885', '0862', '0873', '0919', '0878', '0889', '0819', '022D', '095C', '08A2', '07E4', '0863', '095E', '087D', '0817', '089D', '0940', '088E', '0897', '086E', '023B', '094A', '0959', '091B', '0969', '088C', '0871', '0437', '086D', '0877', '092D', '08A5', '093A', '093F', '08A7', '0369', '0870', '0802', '0362', '0879', '0954', '091F', '08AB', '092C', '0869', '0942', '0884', '086B', '0965', '0925', '0949', '08A6', '0932', '089A', '0882', '0963', '089C', '0922', '092A', '08A0', '0917', '0865', '07EC', '091E', '0937', '093C', '094E', '092E', '0890', '0899', '085B', '0876', '089B', '0946', '0938', '0957', '088B', '0943', '0956', '0936', '08AC', '087B', '088A', '0967', '085E', '094F', '0941', '0361', '0281', '08AD', '095D', '0438', '094C', '0930', '088F', '086F', '08A3', '0811', '093E', '0880', '0887', '0367', '0881', '091D', '0883', '0929', '0952', '0202', '0918', '0894', '0896', '0921', '0436', '0931', '095F', '0892', '093B', '0951', '0920', '092B', '086A', '08AA', '0875', '0866', '0948', '0945', '0950', '0947', '085C', '0861', '0893', '0838', '0962', '092F', '0933', '0888', '0953', '0874', '08A8', '0966', '0868', '091C', '087A', '08A1', '0867', '0935', '0872', '0961', '0955', '095A', '083C', '087F', '085A', '087E', '096A', '0960', '094D', '085F', '095B', '02C4', '0365', '0895', '0923'
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