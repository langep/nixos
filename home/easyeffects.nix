{ pkgs, ... }:
{
  services.easyeffects = {
    enable = true;
    preset = "Broadcast-Mic";

    extraPresets.Broadcast-Mic = {
      input = {
        blocklist = [ ];
        plugins_order = [
          "filter#0"
          "equalizer#0"
          "expander#0"
          "compressor#0"
          "limiter#0"
        ];

        "filter#0" = {
          bypass = false;
          input-gain = 0.0;
          output-gain = 0.0;
          type = "High-pass";
          mode = "BWC (BT)";
          slope = "x3";
          frequency = 75.0;
          width = 4.0;
          quality = 0.0;
          gain = 0.0;
          balance = 0.0;
          decramp = "Off";
          equal-mode = "IIR";
        };

        "equalizer#0" =
          let
            bands = {
              band0 = {
                type = "Bell";
                mode = "BWC (BT)";
                slope = "x1";
                solo = false;
                mute = false;
                gain = -2.0;
                frequency = 225.0;
                q = 0.7;
                width = 4.0;
              };
              band1 = {
                type = "Bell";
                mode = "BWC (BT)";
                slope = "x1";
                solo = false;
                mute = false;
                gain = 1.5;
                frequency = 3000.0;
                q = 0.7;
                width = 4.0;
              };
            };
          in
          {
            bypass = false;
            input-gain = 0.0;
            output-gain = 0.0;
            mode = "IIR";
            decramp = "Off";
            split-channels = false;
            balance = 0.0;
            pitch-left = 0.0;
            pitch-right = 0.0;
            num-bands = 2;
            left = bands;
            right = bands;
          };

        "expander#0" = {
          bypass = false;
          input-gain = 0.0;
          output-gain = 0.0;
          dry = -80.01;
          wet = 0.0;
          mode = "Downward";
          attack = 10.0;
          release = 150.0;
          release-threshold = -80.01;
          # Tune this after measuring the room and keyboard noise floor.
          threshold = -45.0;
          ratio = 2.0;
          knee = -6.0;
          makeup = 0.0;
          stereo-split = false;
          hpf-mode = "Off";
          hpf-frequency = 10.0;
          lpf-mode = "Off";
          lpf-frequency = 20000.0;
          input-to-sidechain = -80.01;
          input-to-link = -80.01;
          sidechain-to-input = -80.01;
          sidechain-to-link = -80.01;
          link-to-input = -80.01;
          link-to-sidechain = -80.01;
          sidechain = {
            type = "Internal";
            mode = "RMS";
            source = "Middle";
            stereo-split-source = "Left/Right";
            preamp = 0.0;
            reactivity = 10.0;
            lookahead = 0.0;
          };
        };

        "compressor#0" = {
          bypass = false;
          input-gain = 0.0;
          output-gain = 0.0;
          dry = -80.01;
          wet = 0.0;
          mode = "Downward";
          attack = 15.0;
          release = 100.0;
          release-threshold = -80.01;
          # Tune for roughly 3-6 dB of gain reduction during normal speech.
          threshold = -18.0;
          ratio = 3.0;
          knee = -6.0;
          makeup = 0.0;
          boost-threshold = -72.0;
          boost-amount = 0.0;
          stereo-split = false;
          hpf-mode = "Off";
          hpf-frequency = 10.0;
          lpf-mode = "Off";
          lpf-frequency = 20000.0;
          input-to-sidechain = -80.01;
          input-to-link = -80.01;
          sidechain-to-input = -80.01;
          sidechain-to-link = -80.01;
          link-to-input = -80.01;
          link-to-sidechain = -80.01;
          sidechain = {
            type = "Feed-forward";
            mode = "RMS";
            source = "Middle";
            stereo-split-source = "Left/Right";
            preamp = 0.0;
            reactivity = 10.0;
            lookahead = 0.0;
          };
        };

        "limiter#0" = {
          bypass = false;
          input-gain = 0.0;
          output-gain = 0.0;
          mode = "Herm Thin";
          oversampling = "None";
          dithering = "None";
          sidechain-type = "Internal";
          lookahead = 5.0;
          attack = 5.0;
          release = 5.0;
          threshold = -1.0;
          gain-boost = false;
          sidechain-preamp = 0.0;
          stereo-link = 100.0;
          alr = false;
          alr-attack = 5.0;
          alr-release = 50.0;
          alr-knee = 0.0;
          alr-knee-smooth = -5.0;
          input-to-sidechain = -80.01;
          input-to-link = -80.01;
          sidechain-to-input = -80.01;
          sidechain-to-link = -80.01;
          link-to-input = -80.01;
          link-to-sidechain = -80.01;
        };
      };
    };
  };

  # Keep hardware as the system default and let applications opt in to the
  # EasyEffects virtual source instead of moving every recording stream.
  systemd.user.services.easyeffects.Service.ExecStartPre = [
    "${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file easyeffects/db/easyeffectsrc --group EffectsPipelines --key processAllInputs false"
    "${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file easyeffects/db/easyeffectsrc --group EffectsPipelines --key processAllOutputs false"
    "${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file easyeffects/db/easyeffectsrc --group StreamInputs --key useDefaultInputDevice true"
  ];
}
