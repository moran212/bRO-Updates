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
	'093C', '08AC', '0958', '0860', '0885', '07E4', '089C', '0890', '0866', '08AA', '08A1', '092C', '088F', '0931', '08A4', '088C', '094E', '088D', '0892', '08A3', '0899', '08A8', '095A', '0366', '0878', '0362', '0926', '0922', '0953', '0887', '0281', '089D', '0437', '0889', '035F', '07EC', '0921', '095B', '0884', '0861', '085F', '0869', '023B', '0945', '0876', '0883', '0942', '0863', '08A0', '0951', '0880', '08AB', '0938', '0950', '08A5', '0819', '0936', '085B', '087C', '085C', '0865', '0360', '08A9', '0924', '0363', '094A', '093A', '08AD', '0874', '0868', '0920', '0361', '08A6', '0949', '0877', '0939', '0961', '085D', '0930', '0864', '0927', '094C', '0917', '0932', '094F', '083C', '087A', '0369', '0964', '092E', '0888', '0879', '0891', '0947', '0954', '0935', '0923', '0886', '092B', '0941', '02C4', '0948', '0962', '088E', '0965', '0937', '088A', '0881', '089F', '0919', '0873', '092F', '095E', '091D', '0966', '022D', '094D', '0968', '0835', '093F', '091B', '093D', '091A', '0882', '0898', '0875', '094B', '0967', '091F', '0963', '0946', '0202', '0943', '0969', '096A', '095F', '0870', '091E', '0955', '087B', '0934', '087F', '0896', '0897', '0959', '0944', '092A', '087E', '0895', '0872', '095D', '086E', '091C', '095C', '0367', '0918', '086B', '0838', '089B', '093E', '0928', '0871', '087D', '0817', '0929', '0893', '0802', '086A', 
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