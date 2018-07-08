require "spec_helper.rb"

describe DataManager do
  #let(:player_name) { 'Test_Player_' + rand(1..9999).to_s }
  player_name = 'Test_Player_' + rand(1..9999).to_s
  context "when testing #write_result method" do
    it 'returns player saved result' do
      allow(subject).to receive(:gets).and_return(player_name)
      subject.write_results(5, true)
      data = File.read('./lib/results.yml')
      expect(data).to include(player_name)
    end
  end
  context 'when testing #view_results method' do
    it 'opens the results file' do
      expect { subject.view_results }.to output(/#{player_name}/).to_stdout
    end
  end
end
