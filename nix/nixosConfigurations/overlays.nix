self: super: {
  input-fonts = super.input-fonts.overrideAttrs (oldAttrs: {
    src = super.fetchzip {
      # This URL is too long for fetchzip, and returns non-reproducible zips with new sha256 every time ☹️
      # url = "https://input.djr.com/build/?customize&fontSelection=fourStyleFamily&regular=InputMonoNarrow-Regular&italic=InputMonoNarrow-Italic&bold=InputMonoNarrow-Bold&boldItalic=InputMonoNarrow-BoldItalic&a=0&g=0&i=serifs_round&l=serifs_round&zero=slash&asterisk=height&braces=0&preset=default&line-height=1.1&accept=I+do&email=";
      url = "https://maximbaz.com/input-fonts.zip";
      sha256 = "09qfb3h2s1dlf6kn8d4f5an6jhfpihn02zl02sjj26zgclrp6blc";
      stripRoot = false;
    };
  });
  # fix missing "bash"
  # darkman = super.darkman.overrideAttrs (oldAttrs: {
  #   src = super.fetchFromGitLab {
  #     owner = "WhyNotHugo";
  #     repo = "darkman";
  #     rev = "3b3c62e329f1538f3bd989b9cb64d6378e68a02f";
  #     sha256 = "18hll8cm73qx389x0y2xxbx8fh1hfxn7zgcxqx4whlnq5lnlxz6k";
  #   };
  # });
}
