#!/usr/bin/env python3
"""pinboard rofi script"""

from pathlib import Path
import os
import json
import yaml
import pinboard
import click


class RofiPinboard:
    """Rofi Pinboard class"""

    book_marks = None
    config = None
    config_file = None
    pin = None

    def __init__(self):
        # set config file
        self.config_file = Path(os.path.join(str(Path.home()), ".rofi-pinboard.yaml"))

    def __setup(self):
        """Setup RofiPinboard"""
        # load api token
        self.load_config()

        # initialise session
        self.pin = pinboard.Pinboard(self.config["api_token"])

    def __load_bookmarks(self):
        bookmarks = None
        temp_dir = self.__get_tmpdir()

        temp_file = Path(os.path.join(str(temp_dir), "bookmarks.pinboard"))
        if temp_file.is_file():
            with open(temp_file) as bfh:
                bookmarks = json.load(bfh)
            temp_file.unlink()
        return bookmarks

    def __get_tmpdir(self):
        """Get the tmpdir"""
        temp_dir = None
        if "TMPDIR" in os.environ:
            temp_dir = Path(os.environ["TMPDIR"])
        else:
            temp_dir = Path("/tmp")

        # check if the temp dir exists
        if not temp_dir.exists() or not temp_dir.is_dir():
            click.echo("Your TMPDIR does not exist.")
            exit(42)

        return temp_dir

    def __save_bookmarks(self):
        """Save bookmarks to tempdir"""
        temp_dir = self.__get_tmpdir()

        temp_file = Path(os.path.join(str(temp_dir), "bookmarks.pinboard"))

        # unlink file if it exists
        if temp_file.exists():
            temp_file.unlink()

        # write bookmarks to file
        with open(temp_file, "w") as foh:
            json.dump(self.book_marks, foh)

    def load_config(self):
        """Load the config"""
        if self.config_file.is_file():
            with open(self.config_file, "r") as cfg_file:
                self.config = yaml.safe_load(cfg_file)
        else:
            print("Could not find the config file.")
            exit(42)

    def get_bookmarks(self):
        """Get the bookmarks and data from"""
        if not self.config:
            self.__setup()

        output = []
        bookmarks = self.pin.posts.all()

        for bookmark in bookmarks:
            pbm = {"url": bookmark.url.rstrip(), "desc": bookmark.description, "tags": ",".join(bookmark.tags), "hash": bookmark.hash}
            output.append(pbm)

        self.book_marks = output
        self.__save_bookmarks()

    def get_url_from_id(self, url_id=None):
        """Get the URL for a given ID"""
        bookmarks = self.__load_bookmarks()
        if not bookmarks:
            click.echo("Bookmarks file seems to be empty.")
            exit(42)
        return bookmarks[url_id]["url"]

    def rofi_print(self):
        """Print urls and tags for rofi."""
        for i, bkm in enumerate(self.book_marks):
            print("{} {} {}".format(i, bkm["url"], bkm["tags"]))

    def save_config(self, config):
        """Save the config file."""
        if not isinstance(config, dict):
            print("Config object not of type dict, aborting.")
            exit(42)
        # write config
        with open(self.config_file, "w") as cfg_file:
            yaml.dump(config, cfg_file, default_flow_style=False)


@click.group()
@click.pass_context
def cli(ctx):
    """Main function"""
    ctx.ensure_object(dict)


@cli.command()
@click.pass_context
def all(ctx):
    """Get all bookmarks"""
    rpb = RofiPinboard()
    rpb.get_bookmarks()
    rpb.rofi_print()


@cli.command()
@click.pass_context
@click.argument("id", type=click.INT)
def url(ctx, id):
    """Get URL for one bookmark"""
    rpb = RofiPinboard()
    uri = rpb.get_url_from_id(id)
    print(uri, end="", flush=True)


@cli.command()
def setup():
    """Setup Pinboard"""
    rpb = RofiPinboard()
    # config
    config = {}

    # api token
    api_token = click.prompt("Please enter your Pinboard API token", type=str)
    config["api_token"] = api_token

    rpb.save_config(config)


if __name__ == "__main__":
    cli()
