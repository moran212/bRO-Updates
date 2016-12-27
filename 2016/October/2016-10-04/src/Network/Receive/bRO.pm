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
	'0924', '0928', '086A', '089A', '0936', '088D', '0918', '08AD', '0886', '0950', '0889', '0897', '0876', '085D', '0945', '0863', '02C4', '093A', '0438', '0437', '08A6', '091F', '0920', '089B', '0895', '093B', '091C', '0879', '0281', '0968', '092F', '0819', '0864', '092A', '091E', '094D', '0870', '08AB', '0946', '08A9', '0364', '0927', '085F', '0962', '0868', '085E', '0893', '0954', '0878', '0919', '0877', '083C', '0926', '0817', '094C', '0361', '088A', '08A5', '087B', '0943', '087A', '0952', '0883', '0815', '0947', '095A', '0931', '095F', '088C', '0969', '0940', '095B', '0934', '089E', '0881', '0967', '0880', '0369', '092D', '0362', '0874', '093D', '0930', '085C', '0925', '0365', '095D', '07E4', '0957', '092C', '0932', '0887', '0929', '0921', '088B', '0882', '089D', '085B', '087D', '0838', '0860', '0865', '0363', '0963', '088F', '08A2', '089F', '0866', '092E', '087F', '08AC', '08A1', '0436', '0368', '0938', '093F', '08A4', '0948', '094E', '0958', '0861', '0862', '095C', '0951', '0872', '091A', '0923', '0896', '0867', '023B', '0898', '0835', '086C', '092B', '0944', '086E', '091B', '093E', '094A', '0888', '0937', '0890', '0202', '0955', '087C', '0367', '0922', '0917', '08A7', '091D', '086F', '0966', '0956', '0964', '086D', '0360', '093C', '0959', '0894', '0933', '094B', '0960', '08A8', '094F', '035F', '0869', '096A', '085A'
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