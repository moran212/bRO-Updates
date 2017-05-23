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
use Log qw(warning debug);
use base 'Network::Receive::ServerType0';
use Globals qw(%charSvrSet $messageSender $monstersList);
use Translation qw(TF);

# Sync_Ex algorithm developed by Fr3DBr
sub new {
	my ($class) = @_;
	my $self = $class->SUPER::new(@_);
	
	my %packets = (
		'0097' => ['private_message', 'v Z24 V Z*', [qw(len privMsgUser flag privMsg)]], # -1
		'0A36' => ['monster_hp_info_tiny', 'a4 C', [qw(ID hp)]],
		'09CB' => ['skill_used_no_damage', 'v v x2 a4 a4 C', [qw(skillID amount targetID sourceID success)]],
	);
	# Sync Ex Reply Array 
	$self->{sync_ex_reply} = {
	'092C', '0931', '08A5', '0951', '0969', '0861', '0925', '088E', '092E', '0927', '0880', '0891', '0964', '0949', '0879', '089C', '0968', '0933', '0281', '091A', '087B', '022D', '088F', '0835', '0884', '093A', '0941', '0838', '093C', '092D', '0923', '086A', '0944', '0928', '0369', '0894', '0865', '0929', '086F', '0936', '0802', '08AB', '092F', '094A', '092A', '094E', '087E', '0363', '086B', '0876', '0868', '08AD', '0360', '08A8', '0886', '0885', '0887', '0362', '035F', '0899', '0437', '094D', '0882', '083C', '085E', '0367', '086C', '087D', '0954', '0878', '0948', '0368', '086E', '0873', '0967', '08A3', '0918', '088A', '0811', '087F', '094C', '089D', '093F', '0961', '0866', '093E', '094B', '0875', '0932', '08A9', '0870', '085D', '0935', '096A', '0919', '0436', '0895', '08A2', '0953', '0938', '0890', '091B', '0869', '0940', '0926', '08AC', '089B', '091D', '0897', '091E', '0950', '08A7', '095E', '07EC', '0947', '095F', '091F', '0942', '0957', '0946', '094F', '0960', '089A', '0943', '08A4', '0921', '0872', '085C', '085F', '0930', '095A', '095C', '0862', '0937', '0934', '023B', '0898', '0881', '093D', '0819', '0952', '0959', '08A1', '0366', '0958', '0965', '0963', '0889', '0202', '088D', '085A', '0917', '093B', '091C', '0863', '07E4', '086D', '02C4', '089F', '089E', '092B', '0864', '0883', '0364', '0945', '0920', '0956', '0962'
	};
	
	foreach my $key (keys %{$self->{sync_ex_reply}}) { $packets{$key} = ['sync_request_ex']; }
	foreach my $switch (keys %packets) { $self->{packet_list}{$switch} = $packets{$switch}; }
	
	my %handlers = qw(
		received_characters 099D
		received_characters_info 082D
		sync_received_characters 09A0
	);

	$self->{packet_lut}{$_} = $handlers{$_} for keys %handlers;
	
	return $self;
}

sub sync_received_characters {
	my ($self, $args) = @_;

	$charSvrSet{sync_Count} = $args->{sync_Count} if (exists $args->{sync_Count});
	
	# When XKore 2 client is already connected and Kore gets disconnected, send sync_received_characters anyway.
	# In most servers, this should happen unless the client is alive
	# This behavior was observed in April 12th 2017, when Odin and Asgard were merged into Valhalla
	for (1..$args->{sync_Count}) {
		$messageSender->sendToServer($messageSender->reconstruct({switch => 'sync_received_characters'}));
	}
}

# 0A36
sub monster_hp_info_tiny {
	my ($self, $args) = @_;
	my $monster = $monstersList->getByID($args->{ID});
	if ($monster) {
		$monster->{hp} = $args->{hp};
		
		debug TF("Monster %s has about %d%% hp left\n", $monster->name, $monster->{hp} * 4), "parseMsg_damage"; # FIXME: Probably inaccurate
	}
}

*parse_quest_update_mission_hunt = *Network::Receive::ServerType0::parse_quest_update_mission_hunt_v2;
*reconstruct_quest_update_mission_hunt = *Network::Receive::ServerType0::reconstruct_quest_update_mission_hunt_v2;

1;