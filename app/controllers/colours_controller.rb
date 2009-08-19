# colours_controller.rb - The Colour Of.
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
class ColoursController < ApplicationController
  # GET /colours
  # GET /colours.xml
  def index
    @colours = Colour.find(:all, :limit => 50)#paginate :page => params[:page], :order => 'updated_at DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @colours }
    end
  end

  # GET /colours/1
  # GET /colours/1.xml
  def show
    @colour = Colour.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @colour }
    end
  end

  # GET /colours/new
  # GET /colours/new.xml
  def new
    @colour = Colour.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @colour }
    end
  end

  # GET /colours/1/edit
  def edit
    @colour = Colour.find(params[:id])
  end

  # POST /colours
  # POST /colours.xml
  def create
    @colour = Colour.new(params[:colour])

    respond_to do |format|
      if @colour.save
        flash[:notice] = 'Colour was successfully created.'
        format.html { redirect_to(@colour) }
        format.xml  { render :xml => @colour, :status => :created, :location => @colour }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @colour.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /colours/1
  # PUT /colours/1.xml
  def update
    @colour = Colour.find(params[:id])

    respond_to do |format|
      if @colour.update_attributes(params[:colour])
        flash[:notice] = 'Colour was successfully updated.'
        format.html { redirect_to(@colour) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @colour.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /colours/1
  # DELETE /colours/1.xml
  def destroy
    @colour = Colour.find(params[:id])
    @colour.destroy

    respond_to do |format|
      format.html { redirect_to(colours_url) }
      format.xml  { head :ok }
    end
  end
end
