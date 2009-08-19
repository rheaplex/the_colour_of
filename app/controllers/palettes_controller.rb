# palettes_controller.rb - The Colour Of.
# Copyright 2009 Rob Myers <rob@robmyers.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class PalettesController < ApplicationController
  # GET /palettes
  # GET /palettes.xml
  def index
    @palettes = Palette.paginate :page => params[:page], :order => 'updated_at DESC'
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @palettes }
    end
  end

  # GET /palettes/1
  # GET /palettes/1.xml
  def show
    @palette = Palette.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @palette }
    end
  end

  # GET /palettes/new
  # GET /palettes/new.xml
  def new
    @palette = Palette.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @palette }
    end
  end

  # GET /palettes/1/edit
  def edit
    @palette = Palette.find(params[:id])
  end

  # POST /palettes
  # POST /palettes.xml
  def create
    @palette = Palette.new(params[:palette])

    respond_to do |format|
      if @palette.save
        flash[:notice] = 'Palette was successfully created.'
        format.html { redirect_to(@palette) }
        format.xml  { render :xml => @palette, :status => :created, :location => @palette }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @palette.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /palettes/1
  # PUT /palettes/1.xml
  def update
    @palette = Palette.find(params[:id])

    respond_to do |format|
      if @palette.update_attributes(params[:palette])
        flash[:notice] = 'Palette was successfully updated.'
        format.html { redirect_to(@palette) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @palette.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /palettes/1
  # DELETE /palettes/1.xml
  def destroy
    @palette = Palette.find(params[:id])
    @palette.destroy

    respond_to do |format|
      format.html { redirect_to(palettes_url) }
      format.xml  { head :ok }
    end
  end
end
