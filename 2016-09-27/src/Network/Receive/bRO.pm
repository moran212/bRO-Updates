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
	'0932', '095C', '0802', '094F', '0939', '092F', '0934', '08A6', '0924', '0952', '0815', '0930', '086D', '089A', '093E', '093A', '093F', '087B', '087D', '0947', '0886', '08A9', '0870', '0892', '087E', '0948', '08A8', '087A', '0368', '0438', '0893', '0953', '086C', '0946', '0819', '095D', '0956', '0894', '0931', '0960', '0965', '095E', '0966', '0951', '0940', '094B', '0365', '094A', '092C', '091B', '02C4', '0874', '0860', '0876', '0958', '089E', '0938', '0937', '0923', '0933', '086B', '08A3', '0918', '0957', '022D', '089B', '0897', '0950', '092D', '08A2', '088A', '0867', '0880', '085B', '0871', '0865', '0917', '08A0', '096A', '07E4', '091A', '095F', '088F', '08A5', '094C', '0817', '0964', '092A', '0919', '0891', '0949', '0369', '08A4', '087C', '0967', '0896', '0436', '0873', '0367', '0866', '0361', '085F', '091E', '0955', '092B', '0882', '0921', '093C', '0881', '0928', '0838', '094E', '0863', '0954', '0890', '035F', '0942', '0962', '0936', '0878', '0362', '088C', '08AC', '0935', '087F', '0895', '091D', '0927', '083C', '0360', '0898', '08AB', '0968', '0885', '0969', '0868', '0883', '0363', '0889', '085E', '07EC', '0963', '0835', '0943', '0941', '088E', '0944', '095A', '085C', '08AA', '0929', '0861', '086F', '0877', '0281', '0364', '0366', '0811', '0920', '089F', '0888', '095B', '093B', '0899', '094D', '0945', '088D', '086A'
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